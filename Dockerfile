FROM ruby:3.3-slim AS builder
WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN bundle config set --local deployment 'true' && \
    bundle config set --local without 'development test' && \
    bundle install

FROM ruby:3.3-slim
WORKDIR /app
RUN groupadd -r appuser && useradd -r -g appuser -u 1001 appuser
COPY --from=builder /app/.bundle ./.bundle
COPY --from=builder /app/vendor ./vendor
COPY Gemfile Gemfile.lock ./
COPY . .
EXPOSE 4567
USER 1001
CMD ["bundle", "exec", "rackup", "-o", "0.0.0.0", "-p", "4567"]