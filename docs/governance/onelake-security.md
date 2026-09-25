---
title: "OneLake Security Guidance for Microsoft Fabric"
description: "Practical security guidance for OneLake permissions, workspace roles, item permissions, OneLake security roles, shortcuts, authentication, audit logs, encryption, and external access controls."
---

# OneLake Security Guidance for Microsoft Fabric

This guide summarizes the key OneLake security concepts that matter when governing Fabric workspaces, lakehouses, warehouses, semantic models, and deployment workflows.

Primary Microsoft reference: [Data security overview - Microsoft Fabric](https://learn.microsoft.com/en-us/fabric/onelake/security/get-started-security#onelake-security)

---

## Security Model Overview

OneLake security has two related layers:

| Layer | What it controls | Examples |
|---|---|---|
| Control plane | What users can manage or administer | Workspace roles, item management, sharing, creating items |
| Data plane | What data users can read or access | OneLake security roles, table/folder access, row constraints, column constraints |

Workspace permissions often grant broad default access to items and data. OneLake security roles provide more granular data-plane controls for users who should be able to access only specific data.

---

## Permission Levels in OneLake

OneLake security is organized around Fabric's hierarchy:

```text
OneLake
`-- Workspace
    `-- Item
        |-- Tables/
        `-- Files/
```

Security can be applied at these practical levels:

- Workspace: managed through Fabric workspace roles.
- Item: managed through item sharing and item permissions.
- Tables and folders: managed through OneLake security roles.
- Rows and columns: managed through OneLake security role constraints where supported.

---

## Workspace Roles

Workspace roles define what users can do inside a workspace. They are primarily control-plane permissions, but they commonly grant data access by default through inherited permissions.

Recommended use:

| Role | Recommended use |
|---|---|
| Admin | Very limited. Workspace owners, platform admins, or break-glass support only. |
| Member | Trusted team leads who manage workspace content and access. |
| Contributor | Developers who create and update items but should not manage all workspace access. |
| Viewer | Consumers and reviewers who need read access only. Use OneLake security roles for granular data access. |

Best practices:

- Assign workspace roles to Microsoft Entra security groups instead of individuals.
- Keep Prod workspace Admin and Member assignments tightly controlled.
- Use Viewer plus OneLake security roles when users need limited data access.
- Review workspace role membership quarterly and before production releases.
- Avoid using workspace roles as the only data security boundary for sensitive lakehouse data.

---

## Item Permissions

Item permissions can grant direct access to a specific Fabric item without making the user a workspace member.

Use item permissions when:

- A user or group needs access to one lakehouse, warehouse, semantic model, or report.
- You do not want to expose the broader workspace.
- A sharing scenario is narrower than workspace membership.

Best practices:

- Prefer group-based item permissions.
- Review direct shares regularly because they can be harder to see than workspace roles.
- Document item-level exceptions in the project governance notes or PR description.
- Use item permissions intentionally; do not use them to bypass workspace governance.

---

## OneLake Security Roles

OneLake security roles are the data-plane security model for OneLake data. They define which data users can access within an item.

Each role is made from four parts:

| Component | Purpose |
|---|---|
| Data | Tables or folders the role can access |
| Permission | What access is granted to that data |
| Members | Users or groups assigned to the role |
| Constraints | Exclusions or filters, such as row or column restrictions |

Important behavior:

- OneLake security roles grant data access to users in the Viewer workspace role or users with Read permission on the item.
- Workspace Admins, Members, and Contributors are not restricted by OneLake security roles and can read/write data in an item regardless of role membership.
- Lakehouses include a DefaultReader role that can grant data access to users with ReadAll permission. Review, edit, or remove it when it does not match your security requirements.

Best practices:

- Use OneLake security roles for least-privilege access to lakehouse data.
- Keep Admin, Member, and Contributor workspace roles limited because those roles bypass OneLake security restrictions.
- Use security groups for role membership.
- Validate row-level and column-level constraints with test users before production promotion.
- Document the intended persona or business purpose for each OneLake security role.

---

## Shortcuts

OneLake shortcuts can expose data stored in another location. Folder security applies based on roles defined in the lakehouse where the data is stored.

Best practices:

- Treat shortcuts as governed data access paths, not just convenience links.
- Confirm users have appropriate access to both the shortcut and the underlying data source.
- Review shortcut permissions during release readiness checks.
- Document shortcut source, owner, and data classification.

---

## Authentication and Service Principals

OneLake uses Microsoft Entra ID for authentication. Users and service principals are mapped to the permissions configured in Fabric.

Best practices:

- Use service principals for automation instead of personal accounts.
- Ensure the Fabric tenant setting allows service principals for the required security group.
- Store app secrets in secure configuration such as GitHub Actions secrets, Azure DevOps variable groups, Key Vault-linked variable groups, or environment-scoped secrets.
- Grant service principals the minimum Fabric workspace role needed for the automation task.
- Rotate secrets on a schedule and after ownership changes.

---

## Audit Logs

Fabric audit logs can be used to track OneLake operations. OneLake operation names can correspond to ADLS-style operations such as file create or delete.

Important limitation:

- OneLake audit logs do not include every read request and do not include requests made to OneLake through all Fabric workloads.

Best practices:

- Use audit logs as one part of monitoring, not as the only data-access control.
- Review workspace access, item permissions, and OneLake security roles regularly.
- Investigate unexpected write, delete, sharing, or permission-change activity.
- Align audit review with the governance checklist and release process.

---

## Encryption and Networking

OneLake data is encrypted at rest by default with Microsoft-managed keys. Customer-managed keys can add another layer of control where supported and required.

Data in transit is encrypted with modern TLS. Fabric negotiates TLS 1.3 where possible and requires at least TLS 1.2 for inbound OneLake communication.

Best practices:

- Use customer-managed keys when policy requires tenant-owned key control.
- Consider Fabric private links for stricter network access requirements.
- Review outbound connectivity requirements for data sources and gateways.
- Validate networking controls in non-production before enabling them for production workspaces.

---

## External Application Access

Fabric tenant admins can allow or restrict applications outside Fabric from accessing OneLake data, such as custom apps using ADLS APIs or OneLake file explorer.

Best practices:

- Disable external OneLake access unless there is a documented business need.
- If enabled, scope access with Entra groups, item permissions, and OneLake security roles.
- Review external access alongside service principal and app registration reviews.
- Confirm custom apps enforce the same user and group access model expected by Fabric governance.

---

## Release Checklist for OneLake Security

Before promoting Fabric data items to Test or Prod, confirm:

- Workspace roles follow least privilege.
- Admin and Member roles are limited to approved owners.
- Viewer access is paired with appropriate OneLake security roles where granular data access is needed.
- Item-level shares are reviewed and documented.
- OneLake security roles are assigned to groups, not ad hoc individuals.
- Row and column constraints are tested with representative users.
- DefaultReader roles are reviewed for lakehouses.
- Shortcuts are documented and security-reviewed.
- Service principals are scoped to the required workspaces and groups.
- Secrets are stored outside source control.
- Audit logging and access review responsibilities are assigned.
- External OneLake access is disabled or explicitly approved.

---

## Common Anti-Patterns

| Anti-pattern | Risk | Better approach |
|---|---|---|
| Giving broad Member access so users can read data | Members bypass OneLake security role restrictions | Use Viewer plus OneLake security roles |
| Managing permissions one user at a time | Access drift and hard-to-audit exceptions | Use Entra security groups |
| Leaving DefaultReader unchanged without review | ReadAll users may get broader lakehouse data access than intended | Review, edit, or remove DefaultReader as needed |
| Treating shortcuts as harmless links | Users may reach governed data through another path | Review shortcut source and permissions |
| Storing service principal secrets in YAML or scripts | Secret exposure and credential reuse | Use secure secrets storage |
| Relying only on audit logs for data protection | Not all read paths are captured | Enforce least privilege and role-based access up front |

---

## Related Microsoft Learn Content

- [Data security overview - Microsoft Fabric](https://learn.microsoft.com/en-us/fabric/onelake/security/get-started-security#onelake-security)
- [OneLake security access control model](https://learn.microsoft.com/en-us/fabric/onelake/security/data-access-control-model)
- [Workspace roles in Microsoft Fabric](https://learn.microsoft.com/en-us/fabric/fundamentals/roles-workspaces)
- [Share items in Fabric](https://learn.microsoft.com/en-us/fabric/fundamentals/share-items)
- [OneLake shortcuts](https://learn.microsoft.com/en-us/fabric/onelake/onelake-shortcuts)