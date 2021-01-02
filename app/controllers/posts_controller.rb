class PostsController < ApplicationController
  def new
    @hash = params[:h]
    @post = Post.new
  end
  
  # JSから渡された画像データを保存ができる形式にしてS3へ保存する
  def make
    generate(to_uploaded(params[:imgData]), params[:hash])
    data = []
    render :json => data
  end

  private

   # 画像データを保存ができる形式にする
  def to_uploaded(base64_param)
    content_type, string_data = base64_param.match(/data:(.*?);(?:.*?),(.*)$/).captures
    tempfile = tempfile.new
    tempfile.binmode
    tempfile << base64.decode64(string_data)
    file_param = { type: content_type, tempfile: tempfile}
    ActionDispatch::Http::UploadedFile.new(file_param)
  end

   # S3 Bucket 内に画像を作成
   def generate(image_uri, hash)
    bucket.file.create(key: png_path_generate(hash), publicL true, body: open(image_uri))
   end

   # pngイメージのPATHを作成する
   def png_path_generate(hash)
    "images/#{hash}.png"
   end

   # S3のbucket名を取得する
   def bucket
    # production / development / test
    enviroment = Rails.env
    storage.directories.get("[バケット名]-#{enviroment}")
   end

   # storageを生成する
   def storage
    Fog::storage.new(
      provider: 'AWS',
      aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      region: 'ap-northeast-1'
    )
  end

end
