![Header](/brand/KABOOM.png)
<h1><b>Kaboom</b></h1>
Track your comic book collection. Kaboom is focused on tracking comic books and issues, and retrieves metadata from the ComicVine API. A bit like how Trakt does so with TMDb.

### Development

Versions:
- Ruby 3.3.1
- Rails 7.0.8

Requirements:
- Redis 6.2+
- Node (yarn)

Easy setup:
```bash
bin/setup
```

Seed the database:
```bash
bin/rails db:seed
```
<sub>Note: Running seeds sends requests to ComicVine servers to import comics and issues. You will need an internet connection and an API key.</sub>

Run the dev server:
```bash
bin/dev
```

#### Testing

All new code should be thoroughly tested. Kaboom uses RSpec as its testing framework.

To run all tests:
```bash
bundle exec rspec
```

While writing tests, you may find it useful for them to run when saving files. To do this, run:
```bash
bundle exec guard
```

#### Linting

Kaboom uses standardrb (.rb) and eslint (.js, .ts) for linting. CI will fail if linting isn't correct.

To fix all fixable linting issues:
```bash
bundle exec standardrb --fix
```

Lint ERB files:
```bash
bundle exec erblint --cache --lint-all
```

Lint all Javascript/Typescript files:
```bash
yarn lint:js --fix
```
