Forward couchdb to host
=======================

    vagrant ssh -- -L15984:db1:5984

Redeploy code without running full deploy
=========================================

    paver sync_web

CouchDB database
================

For integration tests:

    platform_core_test-$(hostname)

    security_test-$(hostname)

Localhost:

    platform_core

    security_test

Running integration test
========================

To run
------

    paver test_integration

Failed with `Connection reset by peer`.  Couchdb is not started.

Solution: Need to refresh db box:

    paver refresh_boxes

    paver start_boxes

Run without gateway (or core)
-----------------------------

    paver test_integration --nogateway
    paver test_integration --nocore

Run individual servers
----------------------

    paver runcore

Debug core
----------

1. Run core server in the foreground:

    paver runcore --profile=integration_test

optionally, run security service:

    paver runsecurity --profile=integration_test.security

and gateway:

    paver rungateway --profile=integration_test

2. Run integration tests without core:

    paver test_integration --nocore

without gateway: `--nogateway`

without security: `--nosecurity`

curl LCP Locally
================

Using integration test fixtures
-------------------------------

See [Debug core](Debug core)

Where to find the fixtures
--------------------------

    lcp/tests/system/local.ini

curl with `lcp_curl`
--------------------

    curl -u 12984d7dac7c4899be1e96a04c3e3b20:8Rtk_0lVjXaFknA-lKcgER3LdeXG7CwnhYhlBiqsu64 http://localhost:4999/v1/pics -d'...'

Security model
==============


Local Splunk
============

    http://localhost:8000/

    pwd: changeyou

Initial data migration
======================

Change the fixture in /lcp/.../fixtures/security.initial.couchfixture

and write a migration in migrations.py:

```python
migration_types.DocFromInitialDataMigration(path_to_fixtures_folder, database, fixture_id)
```
