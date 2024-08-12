#  Ruby- erpweb -  ./Dockerfile
# Use the official Ruby image
FROM ruby:3.3.0

# Install dependencies including default-mysql-client and curl for installing Node.js
# RUN apt-get update -qq && apt-get install -y curl gnupg2 build-essential postgresql-client default-mysql-client default-libmysqlclient-dev libvips poppler-utils
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  curl \
  gnupg2 \
  libvips \
  poppler-utils \
  postgresql-client \
  iputils-ping \
  nano  

# Install Node.js and npm from NodeSource
# RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && apt-get install -y nodejs

# Install Yarn 
# RUN npm install --global yarn

# Set working directory
WORKDIR /app

# Copy Gemfile and Gemfile.lock
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

# Install the specified version of Bundler
RUN gem install bundler -v 2.5.10

# Install gems
RUN bundle install

# This is only for initial container build for volume
# RUN bundle exec rails importmap:install
# RUN bundle exec rails stimulus:install

# Ensure Active Storage is set up
# RUN bundle exec rails active_storage:install

# Precompile assets
RUN bundle exec rails assets:precompile


# Copy the rest of the application code
COPY . /app

# Expose port 3000
EXPOSE 3000

# Add entrypoint script
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

# Start the Rails server
ENTRYPOINT ["/usr/bin/entrypoint.sh"]
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]