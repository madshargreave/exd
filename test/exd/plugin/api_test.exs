defmodule Exd.Plugin.ApiTest do
  use Exd.QueryCase
  alias Exd.Repo

#   describe "GET /comments" do
#     test "it returns list of comments" do
#       Repo.all(
#         from r in api_callback(:get, "/api/v1/comments"),
#         join: c in database("comments"), on: c.user_id = r.context.user_id
#         select: c,
#         into: api_response()
#       )
#     end
#   end

#   describe "GET /comments/:comment_id" do
#     test "it returns comment by id" do
#       Repo.all(
#         from r in api_callback(:get, "/api/v1/comments/:comment_id"),
#         join: c in database("comments"), on: c.id = r.params.comment_id
#         select: c,
#         into: api_response()
#       )
#     end
#   end

  # describe "POST /comments" do
  #   test "it creates a new comment" do
  #     inserts =
  #       from r in api_callback(:post, "/api/v1/comments"),
  #       select: %{
  #         text: r.params.text
  #       },
  #       into: database("comments"),
  #       returning: true

  #     domain =
  #       from c in inserts,
  #       where: success?(c),
  #       select: %{
  #         status: 200,
  #         data: {
  #           id: c.id,
  #           text: c.text,
  #           user_id: c.user_id,
  #           inserted_at: c.inserted_at,
  #           updated_at: c.updated_at
  #         }
  #       },
  #       into: api_response()

  #     errors =
  #       from e in inserts,
  #       where: error?(c)
  #       select: %{
  #         status: status_code(e),
  #         data: %{
  #           type: e.type,
  #           error: e.message
  #         }
  #       },
  #       into: api_response()

  #     events =
  #       from d in domain,
  #       select: %{
  #         type: "comment.created",
  #         data: d
  #       },
  #       into: redis_publish("domain-events")

  #     Repo.start_link([errors, events])
  #   end
  # end

end
