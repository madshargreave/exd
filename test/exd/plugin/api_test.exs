# defmodule Exd.Plugin.FetchTest do
#   use Exd.QueryCase
#   alias Exd.Repo

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

#   describe "POST /comments" do
#     test "it creates a new comment" do
#       comments =
#         from r in api_callback(:post, "/api/v1/comments"),
#         select: %{
#           text: r.body.text
#         },
#         into: database("comments"),
#         returning: r

#       Repo.all(
#         from c in comments,
#         select: c,
#         into: api_response()
#       )
#     end
#   end

# end
