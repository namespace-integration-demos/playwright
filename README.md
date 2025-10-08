# Playwright on Namespace

This repository contains example workflows that show how to run Playwright workflows on [Namespace](https://namespace.so) runners.

We recommend using this workflow as an example: **[01-namespace-cache.yml](.github/workflows/01-namespace-cache.yml)**

- Making optimal use of [Cache Volumes](https://namespace.so/docs/solutions/github-actions/caching) greatly reduces the setup time before running playwright.
- Making full use of the CPUs on our high-performance [Compute Platform](https://namespace.so/docs/architecture/compute) reduces test times.
