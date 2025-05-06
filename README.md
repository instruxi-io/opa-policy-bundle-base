# OPA Policy Bundle Base

## Introduction

Welcome to the `opa-policy-bundle-base` repository by Instruxi.io. This repository serves as a foundation for creating, managing, and distributing policy bundles for the Open Policy Agent (OPA) - an open source, general-purpose policy engine that enables unified, context-aware policy enforcement across your entire stack.

## What is OPA?

Open Policy Agent (OPA) is a powerful policy engine that allows you to decouple policy from code. It provides a high-level declarative language called Rego for expressing policies that govern how your system should behave. These policies help you answer questions like:

- Can user X call API Y?
- Is deployment Z allowed in the production environment?
- What cloud resources can team A access?

## Repository Structure

The repository is organized to provide a clean separation of policy types:

```
opa-policy-bundle-base/
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

This structure allows you to:
- Group related policies in subdirectories
- Keep authorization and validation policies separate
- Maintain common utilities for reuse across policies
- Associate tests with specific policy domains

## Working with Policy Bundles

### Creating Bundles

OPA bundles are tar.gz archives containing policy files and related data. Here's how to create different types of bundles:

```bash
# Create a complete bundle with all policies
tar -czf opa-bundle.tar.gz policies/

# Create a bundle excluding test files
tar --exclude='tests' -czf opa-bundle.tar.gz policies/

# Create a specialized authorization bundle
tar -czf authz-bundle.tar.gz policies/authz/
```

### Using Bundles

Once you've created a bundle, you can use it with OPA in various ways:

```bash
# Start OPA with a bundle
opa run -b opa-bundle.tar.gz

# Start OPA server with the bundle
opa run --server --addr :8181 -b opa-bundle.tar.gz

# Configure OPA to automatically download and update bundles
opa run --server \
  --bundle-url=https://example.com/bundles/opa-bundle.tar.gz \
  --bundle-polling-interval=30s
```

## Testing Policies

Comprehensive testing ensures your policies work as expected. Run tests using:

```bash
opa test policies/ tests/ -v
```

## Integration with WebContainer API

To integrate this policy bundle base with WebContainer environments like StackBlitz, you can use the following script:

```javascript
import { WebContainer, FileSystemTree } from '@webcontainer/api';
import { projectFiles } from './project-files.ts';

async function main() {
  // Boot the WebContainer
  const webcontainer = await WebContainer.boot();
  
  // Mount project files into the container's file system
  await webcontainer.mount(projectFiles);
    
  // Install dependencies
  const install = await webcontainer.spawn('npm', ['i']);
  await install.exit;
  
  // Set up OPA binary permissions
  const chmodOpa = await webcontainer.spawn('chmod', ['+x', './opa']);
  await chmodOpa.exit;
  
  // Run OPA to bundle the policy files
  const opaBundle = await webcontainer.spawn('./opa', [
    'build', 
    'policies/', 
    '-o', 
    'bundle.tar.gz'
  ]);
  
  // Wait for OPA bundling to complete
  const opaBundleResult = await opaBundle.exit;
  
  // Log the result of the OPA bundling operation
  console.log(`OPA bundle operation completed with exit code: ${opaBundleResult.code}`);
  
  // Run your application's dev server
  if (opaBundleResult.code === 0) {
    console.log('OPA bundle created successfully at bundle.tar.gz');
    await webcontainer.spawn('npm', ['run', 'dev']);
  } else {
    console.error('OPA bundle creation failed');
  }
}

// Start the process
main().catch(console.error);
```

## Contributing

To contribute to this repository:
1. Create new policy files in the appropriate subdirectory
2. Add corresponding test cases in the `tests/` directory
3. Ensure all tests pass before bundling
4. Update the README if adding new policy categories

## Learn More

For more information about OPA and Rego, visit the [official documentation](https://www.openpolicyagent.org/docs/latest/).
