# channels_source = %Exd.Query{
#   from: {
#     SQLSource,
#       hostname: {:secret, "DB_HOSTNAME"},
#       database: {:secret, "DB_DATABASE"},
#       username: {:secret, "DB_USERNAME"},
#       password: {:secret, "DB_PASSWORD"},
#       schedule: {
#         :every, {5, :minute}
#       },
#       query: "
#         SELECT id, network_id
#         FROM channels
#         WHERE locked_at IS NULL AND synced_at < ('5 min'::interval)::timestamp
#       "
#   }
# }

# shares_api = %Exd.Query{
#   from: {
#     RequestSource,
#       url: "https://api.linkedin.com/v1/shares",
#       params: [
#         app_id: {:secret, "API_APP_ID"},
#         app_secret: {:secret, "API_APP_SECRET"},
#         channel: {:arg, "network_id"}
#       ],
#       pagination: [
#         until: {:timestamp, "1 month ago"}
#         pattern: {:url, "page={{page}}"}
#       ],
#       concurreny: 10,
#       timeout: 5000
#   },
#   select: %{
#     id: {:access, "data.id"},
#     text: {:access, "data.text"},
#     timestamp: {:access, "data.timestamp"}
#   }
# }

# shares_store = {
#   StoreSource,
#     key: "id",
#     adapter: {
#       MemoryStore,
#         name: :my_store
#     }
# }

# shares =
#   Exd.Query.new
#   |> Exd.Query.from("channels", channels)
#   |> Exd.Query.join("shares", shares_api, network_id: "channels.network_id")
#   |> Exd.Query.join("existing", shares_store, id: "shares.id")
#   |> Exd.Query.select(%{
#     is_new: {:=, "existing.id", nil},
#     is_changed: {
#       {
#         :and,
#         {:=, "existing.id", "shares.id"},
#         {:<>, "existing.hash", "shares.hash"}
#       }
#     },
#     data: {
#       :build_json_object, "shares"
#     }
#   })

# new_shares =
#   Exd.Query.new
#   |> Exd.Query.from("shares", shares)
#   |> Exd.Query.where(:is_new, :=, true)
#   |> Exd.Query.select(%{
#     event: :created,
#     data: "shares.data"
#   })

# changed_shares =
#   Exd.Query.new
#   |> Exd.Query.from("shares", shares)
#   |> Exd.Query.where(:is_changed, :=, true)
#   |> Exd.Query.select(%{
#     event: :updated,
#     data: "shares.data"
#   })

# share_events =
#   Exd.Query.new
#   |> Exd.Query.from("events", [new_shares, changed_shares])
#   |> Exd.into({
#     RedisSource,
#       hostname: {:secret, "REDIS_HOSTNAME"},
#       topic: {:secret, "REDIS_TOPIC"}
#   })
#   |> Exd.into({
#     StoreSource,
#       key: "id",
#       adapter: {
#         MemoryStore,
#           name: :my_store
#       }
#   })
#   |> Exd.Repo.run()

# redis_shares =
#   Exd.Query.new
#   |> Exd.Query.from("shares", [
#     {
#       RedisSource,
#         hostname: {:secret, "REDIS_HOSTNAME"},
#         topic: {:secret, "REDIS_TOPIC"}
#     }
#   ])
#   |> Exd.Query.where("shares.event", :=, :created)
#   |> Exd.Query.select(%{
#     share_id: "shares.id"
#   })

# scheduled_shares =
#   Exd.Query.new
#   |> Exd.Query.from("shares", [
#     {
#       SQLSource,
#         hostname: {:secret, "DB_HOSTNAME"},
#         database: {:secret, "DB_DATABASE"},
#         username: {:secret, "DB_USERNAME"},
#         password: {:secret, "DB_PASSWORD"},
#         schedule: {
#           :every, {5, :minute}
#         },
#         query: "
#           SELECT id
#           FROM shares
#           WHERE locked_at IS NULL AND synced_at < ('5 min'::interval)::timestamp
#         "
#     }
#   ])
#   |> Exd.Query.select(%{
#     share_id: "shares.id"
#   })

# comments =
#   Exd.Query.new
#   |> Exd.Query.from("events", [redis_shares, scheduled_shares])
#   |> Exd.Query.join("comments", comments_source, share_id: "events.share_id")
#   |> Exd.Query.join("existing", comments_store, id: "shares.id")
#   |> Exd.Query.select(%{
#     is_new: {:=, "existing.id", nil},
#     is_changed: {
#       {
#         :and,
#         {:=, "existing.id", "comments.id"},
#         {:<>, "existing.hash", "comments.hash"}
#       }
#     },
#     data: {
#       :build_json_object, "comments"
#     }
#   })

# new_comments =
#   Exd.Query.new
#   |> Exd.Query.from("comments", comments)
#   |> Exd.Query.where(:is_new, :=, true)
#   |> Exd.Query.select(%{
#     event: :created,
#     data: "comments.data"
#   })
