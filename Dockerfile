FROM ruby:3.3-slim AS builder
WORKDIR /app
RUN apt-get update && apt-get install -y --no-install-recommends build-essential && rm -rf /var/lib/apt/lists/*
COPY Gemfile ./
RUN bundle install

FROM ruby:3.3-slim
WORKDIR /app
RUN groupadd -r appuser && useradd -r -g appuser -u 1001 appuser
COPY --from=builder /app/.bundle ./.bundle
COPY --from=builder /app/vendor ./vendor
COPY Gemfile ./
COPY . .
EXPOSE 4567
USER 1001
CMD ["bundle", "exec", "rackup", "-o", "0.0.0.0", "-p", "4567"]