FROM ruby:3.3.0

RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  curl \
  gnupg2 \
  libvips \
  poppler-utils \
  postgresql-client \
  iputils-ping \
  nano  \
  cron

RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && \
    apt-get install -y nodejs && \
    corepack enable && corepack prepare yarn@stable --activate

# Set working directory
WORKDIR /app

ARG SECRET_KEY_BASE

# Rails ENV
ENV RAILS_ENV production
ENV RAILS_SERVE_STATIC_FILES true
ENV RAILS_LOG_TO_STDOUT true
ENV BUNDLER_WITHOUT 'development test'

# Copy the rest of the application code
COPY Gemfile Gemfile.lock   ./
COPY .ruby-version          .ruby-version
COPY config.ru              config.ru
COPY Rakefile               Rakefile
COPY bin                    bin/
COPY config                 config/
COPY db                     db/
COPY lib                    lib/
COPY app                    app/
COPY public                 public/
COPY vendor                 vendor/
COPY sorbet                 sorbet/
COPY imports                imports/
COPY log                    log/
COPY Procfile.prod          Procfile.prod

# Install Bundler
RUN gem install bundler -v 2.5.10

# Install gems
RUN bundle install

# Precompile Assets
RUN SECRET_KEY_BASE=${SECRET_KEY_BASE} bin/rake assets:precompile --trace

# Install Foreman
RUN gem install foreman

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

# Expose port 3000
EXPOSE 3000

# Start the Rails server
ENTRYPOINT ["/usr/bin/entrypoint.sh"]
CMD ["foreman", "start", "-f", "Procfile.prod"]
