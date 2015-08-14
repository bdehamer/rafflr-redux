FROM ruby:2.2.2-slim
RUN apt-get update && apt-get install -y build-essential libsqlite3-dev

WORKDIR /usr/src/app

COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/
RUN bundle install

COPY . /usr/src/app/
RUN rake db:migrate

CMD ["rails", "s", "-b", "0.0.0.0"]
