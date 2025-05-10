install:
    git submodule update --init --recursive
    bundle install

run:
    bundle exec ruby main.rb

format-code +files="":
    bundle exec standardrb --fix {{files}}

generate-classes:
    bundle exec ruby scripts/generate_dap_classes.rb
