defmodule CaptainFactGraphql.Schema do
  use Absinthe.Schema
  import_types CaptainFactGraphql.Schema.ContentTypes
  alias CaptainFactGraphql.Resolvers

  # Actual API

  input_object :video_filter do
    field :language, :string
    field :min_id, :id
    field :speaker_id, :id
    field :speaker_slug, :string
  end

  query do
    @desc "Get all videos"
    field :all_videos, list_of(:video) do
      arg :filters, :video_filter
      resolve &Resolvers.Videos.list/3
    end

    @desc "Get a single video"
    field :video, :video do
      arg :id, :id
      arg :hash_id, :video_hash_id
      arg :url, :string
      resolve &Resolvers.Videos.get/3
    end

    @desc "Get app info"
    field :app_info, :app_info do
      resolve &Resolvers.AppInfo.info/3
    end

    @desc "get all_statistics"
    field :all_statistcs, :statistics do
      resolve &Resolvers.Statistics.get/2
    end
  end
end