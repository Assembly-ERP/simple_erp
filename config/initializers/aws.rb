require 'aws-sdk-core'

Aws.config.update(
  {
    region: ENV.fetch('S3_REGION', nil),
    endpoint: ENV.fetch('S3_ENDPOINT', nil),
    credentials: Aws::Credentials.new(ENV.fetch('S3_ACCESS_KEY_ID', nil), ENV.fetch('S3_ACCESS_KEY', nil))
  }
)
