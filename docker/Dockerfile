###############################################################################
FROM ruby:4.0.0-alpine AS ruby-base

RUN apk --no-cache add imagemagick sqlite-dev

###############################################################################
FROM ruby-base AS ruby-build

RUN apk --no-cache add build-base

WORKDIR /app
COPY ./ /app
RUN bundle install --deployment --without test development

###############################################################################
FROM ruby-base AS ruby-app

COPY --from=ruby-build /app /app
COPY --from=ruby-build /usr/local/bundle /usr/local/bundle

WORKDIR /app
EXPOSE 80
ENV APP_ENV production
ENV RACK_ENV production
CMD ["bundle", "exec", "ruby", "app.rb", "-p 80"]
