###############################################################################
FROM ruby:3.1.2-alpine AS ruby-base

RUN apk --no-cache add imagemagick
RUN gem update bundler

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
CMD ["ruby", "app.rb", "-p 80"]
