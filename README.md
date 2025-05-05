# Rego Policy Bundle

This repository contains Rego policies for use with Open Policy Agent (OPA).

## Overview

Rego is a high-level declarative language designed for expressing policies. These policies can be used to enforce access control, validate configuration, and more across your infrastructure and applications.

## Directory Structure

```
rego-policies/
├── policies/
│   ├── authz/
│   │   ├── rbac.rego
│   │   └── abac.rego
│   ├── validation/
│   │   ├── k8s.rego
│   │   └── terraform.rego
│   └── common/
│       └── utils.rego
└── tests/
    ├── authz_test.rego
    └── validation_test.rego
```

## Policy Naming Conventions

- All policy files should end with `.rego` extension
- Use descriptive names that reflect the policy's purpose
- Group related policies in subdirectories

## Creating a Bundle

To create a tar bundle of these policies for distribution and deployment:

### Basic Tar Bundle

```bash
tar -czf rego-bundle.tar.gz rego-policies/
```

### Excluding Test Files

```bash
tar --exclude='rego-policies/tests' -czf rego-bundle.tar.gz rego-policies/
```

### Creating a Bundle with Specific Policies

```bash
tar -czf authz-bundle.tar.gz rego-policies/policies/authz/
```

## Using the Bundle with OPA

### Running OPA with the Bundle

```bash
# Start OPA with the bundle
opa run -b rego-bundle.tar.gz

# Start OPA server with the bundle
opa run --server --addr :8181 -b rego-bundle.tar.gz
```

### Updating Bundles

OPA can automatically download and update bundles from a server:

```bash
opa run --server \
    --bundle-url=https://example.com/bundles/rego-bundle.tar.gz \
    --bundle-polling-interval=30s
```

## Testing Policies

Run tests using the OPA test command:

```bash
opa test rego-policies/ -v
```

## Contributing New Policies

1. Create new policy files in the appropriate subdirectory
2. Add corresponding test cases in the `tests/` directory
3. Ensure all tests pass before bundling
4. Update this README if adding new policy categories

## License

[Specify your license here]

---

For more information about OPA and Rego, visit the [official documentation](https://www.openpolicyagent.org/docs/latest/).
