# sentiment =
#   Exd.Query.new
#   |> Exd.Query.from(
#     "input",
#     {
#       RequestSource,
#         method: "post",
#         url: "https://api.metricsgat.io/v1/sentiment"
#     }
#   )
#   |> Exd.Query.select(%{
#     id: "id"
#     text: "text"
#     score: "sentiment.score"
#   })

# assert [
#   [
#     %{id: 1, text: "hello there", score: 0.9},
#     %{id: 2, text: "hello there", score: 0.9},
#     %{id: 3, text: "hello there", score: 0.9}
#   ],
#   [
#     %{id: 4, text: "hello there", score: 0.9},
#     %{id: 5, text: "hello there", score: 0.9},
#   ]
# ] ==
#   Exd.Query.new
#   |> Exd.Query.from(
#     "messages",
#     {
#       ListSource,
#         value: [
#           %{id: 1, content: "hello there"},
#           %{id: 3, content: "hello there"},
#           %{id: 2, content: "hello there"},
#           %{id: 4, content: "hello there"},
#           %{id: 5, content: "hello there"},
#         ]
#     }
#   )
#   |> Exd.Query.join("sentiment", sentiment, id: "messages.id", text: "message.content")
#   |> Exd.Query.where("sentiment.score", :>, 0.8)
#   |> Exd.Query.select(%{
#     id: "messages.id",
#     text: "messages.text",
#     score: "messages.score"
#   })
#   |> Exd.Repo.run


raw = "
  CREATE SOURCE plugins.email (
    to string,
    from string,
    subject string,
    message string
  ) RETURNS void
  LANGUAGE SQL
  AS $$
  WITH request AS (
    SELECT
      'post' AS method,
      'https://sendgrid.com/api/v3/send' AS url,
      array_agg(
        json_build_object(
          'email', json_build_object(
            'to', __args__.to,
            'from', __args__.from,
            'subject', __args__.subject,
            'content', __args__.content
          )
        )
      ) AS payload
      FROM __args__
      GROUP BY WINDOW COUNT 5
  )
    INSERT INTO requests (method, url, data)
    SELECT method, url, data
    FROM request
  $$

  CREATE TYPE sentiment_result (_key string, status string, score float);
  CREATE SOURCE plugins.sentiments (
    id string,
    text string
  ) RETURNS sentiment_result
  LANGUAGE SQL
  AS $$
    WITH payload AS (
      SELECT
        'post' AS method,
        'https://sentimentio.io/api/v3/sentiment' AS url,
        array_agg(
          json_build_object(
            'data': json_build_object(
              'id': __args__.id,
              'text': __args__.text
            )
          )
        ) AS payload,
        3 AS retries,
        '5 seconds'::interval AS timeout
      FROM __args__
      GROUP BY WINDOW COUNT 5
    ) response AS (
      INSERT INTO requests (
        method,
        url,
        data,
        retries,
        timeout
      )
      SELECT method, url, payload, retries, timeout
      FROM payload
      RETURNING *
    )
    SELECT
      _key,
      payload->'score' AS score
    FROM response
    )
  $$;

  WITH positive_messages AS (
    SELECT *
    FROM [
      ('id': 1, 'channel_id': 1, 'text': 'hello there'),
      ('id': 2, 'channel_id': 1, 'text': 'hello there'),
      ('id': 3, 'channel_id': 1, 'text': 'hello there'),
      ('id': 4, 'channel_id': 1, 'text': 'hello there'),
      ('id': 5, 'channel_id': 1, 'text': 'hello there')
    ] input
    JOIN channels c ON c.id = input.channel_id
    JOIN sentiment s ON s.text = input.text
    WHERE s.score > 0.9
  ), emails AS (
    INSERT INTO emails (to, from, subject, content)
    SELECT
      c.email,
      'alerts@sentimenter.io',
      REPLACE('[?] Sentiment Alert!', c.name),
      REPLACE('hello you got a new happy message: ?', input.text),
    FROM positive_messages
  ), push AS (
    INSERT INTO push (token, title, message)
    SELECT
      p.push_token,
      'Sentiment alert',
      REPLACE('hello you got a new happy message: ?', p.text),
    FROM positive_messages p
    WHERE p.push_token IS NOT NULL
  )
  SELECT *
  FROM positive_messages
"
