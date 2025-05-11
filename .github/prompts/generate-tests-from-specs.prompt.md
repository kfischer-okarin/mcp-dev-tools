Look at the #changes of the <spec> section and update the tests to ensure the
new specs are fulfilled.

## Coding Style

- Use minitest/spec style for the tests
  <bad_example>
  class MyTest < Minitest::Test
    def test_something
  </bad_example>
  <good_example>
  describe MyTest do
    it 'does something' do
  </good_example>
- Use `value` instead of `_` for the expectations
  <bad_example>
  _(result).must_equal 42
  </bad_example>
  <good_example>
  value(result).must_equal 42
  </good_example>
- Do not use describe blocks for methods when testing classes. Make all test
  cases state facts about the behavior of the class itself
  <bad_example>
  describe MyClass do
    describe '#my_method' do
      it 'does something' do
  </bad_example>
  <good_example>
  describe MyClass do
    it 'does something' do
  </good_example>
- Use Arrange/Act/Assert style for the tests, separating the three parts with a
  blank line
- If there are existing tests in the same file, try to match their style and
  reuse helpers or fixtures if possible

## Test Generation Instructions

- NEVER change the comment block containing the specs
- Each of the specs MUST be covered by the tests. Usually each spec SHOULD
  have at least one corresponding test. But you MAY omit specs that are only
  confirming the signature of a method or class
- You MUST NOT look at the implementation file that is tests - the specs should
  be the only source of truth for the tests. There is no need to understand the
  the current implementation of the code to write the tests
- Finally run the tests, it's expected that every test you added or changed
  will fail (since the implementation is not yet updated), but all the other
  tests should pass
- Use TestHelper.path_relative_from_project_root to construct paths since it
  is safer than trying to construct them manually