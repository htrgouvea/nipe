# Testing Guide

Testing guidance for Nipe, including manual verification and optional coverage analysis when a test suite exists.

## Table of Contents

- [Manual Testing](#manual-testing)
- [Test Coverage](#test-coverage)
- [Writing Tests](#writing-tests)
- [Test Structure](#test-structure)
- [Continuous Integration](#continuous-integration)

---

## Manual Testing

Follow the manual verification flow in `docs/developer-guide/getting-started.md` to validate install/start/status/restart/stop on your target distribution.

---

## Test Coverage

### Install Coverage Tool

```bash
# Install Devel::Cover
cpanm Devel::Cover
```

### Generate Coverage Report (Manual Way)

```bash
# Step 1: Clean old coverage data
cover -delete

# Step 2: Run tests with coverage
PERL5OPT=-MDevel::Cover prove -lv tests/

# Step 3: Generate coverage report
cover

# Step 4: View text summary
cover -report text

# Step 5: View detailed report
cover -report html_minimal
```

### View Coverage Report

#### Text Summary

```bash
# Quick summary in terminal
cover -report text
```

Example output:
```
----------------------------------- ------ ------ ------ ------ ------ ------
File                                 stmt   bran   cond    sub   time  total
----------------------------------- ------ ------ ------ ------ ------ ------
lib/Nipe/Component/Engine/Start.pm  95.2   87.5   75.0  100.0   25.5   92.3
lib/Nipe/Component/Engine/Stop.pm   98.5  100.0   n/a   100.0   12.3   98.8
lib/Nipe/Component/Utils/Device.pm 100.0  100.0  100.0  100.0   15.2  100.0
lib/Nipe/Component/Utils/Helper.pm 100.0   n/a    n/a   100.0    5.1  100.0
lib/Nipe/Component/Utils/Status.pm  92.8   80.0   66.7  100.0   18.7   88.5
lib/Nipe/Network/Install.pm         96.4   90.0   n/a   100.0   13.8   95.6
lib/Nipe/Network/Restart.pm        100.0  100.0   n/a   100.0    9.4  100.0
Total                               96.7   91.3   78.9  100.0  100.0   94.7
----------------------------------- ------ ------ ------ ------ ------ ------
```

#### HTML Report

```bash
# Generate HTML report
cover

# Open in browser
# macOS:
open cover_db/coverage.html

# Linux:
xdg-open cover_db/coverage.html

# Windows:
start cover_db/coverage.html
```

The HTML report shows:
- Overall coverage percentage
- Per-file coverage breakdown
- Color-coded line coverage (green = covered, red = not covered)
- Branch and condition coverage
- Clickable file navigation

#### JSON Report

```bash
# Generate JSON report for CI/CD
cover -report json
```

### Understanding Coverage Metrics

Coverage report shows several metrics:

1. **stmt (Statement)**: Percentage of code statements executed
   - Target: >80%
   - Shows which lines of code ran

2. **bran (Branch)**: Percentage of branches (if/else) tested
   - Target: >75%
   - Shows if both true/false paths tested

3. **cond (Condition)**: Percentage of boolean conditions tested
   - Target: >70%
   - Shows if all combinations tested (e.g., `$a && $b`)

4. **sub (Subroutine)**: Percentage of subroutines called
   - Target: 100%
   - Shows which functions were tested

5. **total**: Overall weighted coverage
   - Target: >85%

### Coverage Goals

| Module | Target | Current |
|--------|--------|---------|
| Utils::Device | 100% | ~100% |
| Utils::Status | 90% | ~95% |
| Utils::Helper | 100% | 100% |
| Engine::Stop | 95% | ~90% |
| Engine::Start | 90% | ~85% |
| Network::Install | 95% | ~95% |
| Network::Restart | 100% | 100% |
| **Overall** | **90%** | **~90%** |

### Improve Coverage

If coverage is low for a module:

1. **Check uncovered lines**:
   ```bash
   # View which lines aren't covered
   cover -report text
   # Look for red/uncovered lines in HTML report
   ```

2. **Add tests for uncovered paths**:
   - Error handling paths
   - Edge cases
   - Different distributions
   - Failure scenarios

3. **Example**: If `Start.pm` has 85% coverage:
   ```perl
   # Check which lines aren't tested
   # Add test for that scenario
   subtest 'Test uncovered scenario' => sub {
       # Test code
   };
   ```

### Coverage in CI/CD

Add to GitHub Actions workflow:

```yaml
- name: Run tests with coverage
  run: |
    cpanm Devel::Cover
    cover -delete
    PERL5OPT=-MDevel::Cover prove -lv tests/
    cover -report coveralls
```

---

## Writing Tests

### Test Template

```perl
#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::MockModule;

use lib './lib';

# Module to test
BEGIN {
    use_ok('Nipe::YourModule');
}

subtest 'Feature description' => sub {
    plan tests => 3;

    # Setup
    my $mock = Test::MockModule->new('Dependency::Module');
    $mock->mock('method', sub { return 'mocked'; });

    # Execute
    my $result = Nipe::YourModule->new();

    # Assert
    ok($result, 'Returns truthy value');
    is($result, 1, 'Returns success');
    like($result, qr/pattern/, 'Matches pattern');
};

done_testing();
```

### Mocking Examples

#### Mock System Calls

```perl
my @system_calls;

BEGIN {
    *CORE::GLOBAL::system = sub {
        push @system_calls, "@_";
        return 0; # Success
    };
}

# Test
@system_calls = ();
MyModule->new();
ok((grep { /expected/ } @system_calls), 'Called expected command');
```

#### Mock HTTP Requests

```perl
my $http_mock = Test::MockModule->new('HTTP::Tiny');

$http_mock->mock('get', sub {
    return {
        status  => 200,
        content => '{"key":"value"}',
    };
});
```

#### Mock File Operations

```perl
my $config_mock = Test::MockModule->new('Config::Simple');

$config_mock->mock('new', sub {
    return bless {}, 'Config::Simple';
});

$config_mock->mock('param', sub {
    my ($self, $param) = @_;
    return 'test-value';
});
```

### Test Best Practices

1. **One concept per test**
   ```perl
   # Good
   subtest 'Returns success' => sub { ... };
   subtest 'Handles errors' => sub { ... };

   # Bad - testing multiple things
   subtest 'Everything' => sub {
       # Tests success, errors, edge cases...
   };
   ```

2. **Use descriptive names**
   ```perl
   # Good
   subtest 'Debian uses debian-tor user' => sub { ... };

   # Bad
   subtest 'Test 1' => sub { ... };
   ```

3. **Test both success and failure**
   ```perl
   subtest 'Success case' => sub { ... };
   subtest 'Failure case' => sub { ... };
   subtest 'Edge case' => sub { ... };
   ```

4. **Clean up after tests**
   ```perl
   subtest 'My test' => sub {
       # Setup
       my $temp_file = '/tmp/test';

       # Test
       # ...

       # Cleanup
       unlink $temp_file if -e $temp_file;
   };
   ```

---

## Test Structure

### Directory Organization

If you add automated tests, place them under `tests/` and group them by intent (e.g., unit, integration, fixtures).

### Test File Naming

- Use `.t` extension
- Name after the module: `Device.pm` → `device.t`
- Use lowercase with underscores: `full_cycle.t`

### Test Organization

```perl
#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;

# 1. Module import
use lib './lib';
BEGIN {
    use_ok('Module::Name');
}

# 2. Setup mocks (if needed)
my $mock = Test::MockModule->new('Dependency');

# 3. Test suites
subtest 'Feature A' => sub { ... };
subtest 'Feature B' => sub { ... };
subtest 'Edge cases' => sub { ... };

# 4. Cleanup (if needed)

# 5. Finish
done_testing();
```

---

## Continuous Integration

### GitHub Actions Example

Create `.github/workflows/test.yml`:

```yaml
name: Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3

      - name: Setup Perl
        uses: shogo82148/actions-setup-perl@v1
        with:
          perl-version: '5.30'

      - name: Install dependencies
        run: |
          cpanm --installdeps .
          cpanm Devel::Cover

      - name: Run tests
        run: prove -lv t/

      - name: Coverage report
        run: |
          cover -delete
          PERL5OPT=-MDevel::Cover prove -lv t/
          cover -report text
```

### Coverage Badges

Add coverage badge to README:

```markdown
![Coverage](https://img.shields.io/badge/coverage-90%25-brightgreen)
```

---

## Troubleshooting

### Tests Won't Run

```bash
# Check Perl version
perl -v

# Check module loading
perl -I./lib -MNipe::Component::Utils::Device -e 'print "OK\n"'

# Check dependencies
cpanm --installdeps .
```

### Coverage Report Empty

```bash
# Ensure Devel::Cover is installed
cpanm Devel::Cover

# Run from project root
cd /path/to/nipe
PERL5OPT=-MDevel::Cover prove -lv tests/
```

### Mock Not Working

```perl
# Ensure mock is created BEFORE module use
my $mock = Test::MockModule->new('Module');  # First
$mock->mock('method', sub { ... });           # Second
use Module;                                   # Third (or in BEGIN)
```

### System Call Mock Not Working

```perl
# Must be in BEGIN block
BEGIN {
    *CORE::GLOBAL::system = sub { ... };
}
```

---

## Quick Reference

### Coverage
```bash
cover -delete             # Clean
PERL5OPT=-MDevel::Cover prove -lv tests/  # Run with coverage
cover                     # Generate report
cover -report text        # Text summary
open cover_db/coverage.html  # View HTML
```

### Common Test Commands
```perl
ok($test, 'description')           # Boolean test
is($got, $expected, 'desc')        # Equality test
isnt($got, $unexpected, 'desc')    # Inequality test
like($string, qr/pattern/, 'desc') # Regex test
can_ok($module, @methods)          # Method existence
isa_ok($object, 'Class')           # Type test
dies_ok { code } 'desc'            # Expects to die
```

---

**See also:**
- [Test::More documentation](https://perldoc.perl.org/Test::More)
- [Devel::Cover documentation](https://metacpan.org/pod/Devel::Cover)
