---
title: "Nonprofit Membership Tracking - [Flow Name] Flow Design"
project: "Nonprofit Membership Tracking"
type: "Flow"
phase: "Design"
status: "Draft"
version: "0.1"
created: "YYYY-MM-DD"
updated: "YYYY-MM-DD"
author: "Flow Design Team"
---

# [Flow Name] Flow Design

## Overview

[Brief description of the flow's purpose, objectives, and business context. Explain what process this flow automates and its value to the organization.]

## Flow Metadata

- **API Name**: NMT_[FlowName]_Flow
- **Type**: [Screen Flow/Auto-launched Flow/Scheduled Flow]
- **Description**: [1-2 sentence description for the admin UI]
- **Runtime**: [User/System]
- **Protection**: [Protected/Unprotected]
- **Categories**: [Relevant categories, comma-separated]

## Flow Diagram

```
START
  │
  ▼
[FIRST STEP]
  │
  ▼
[DECISION POINT]
  │
  ├─► [OPTION 1]
  │       │
  │       ▼
  │   [SUBSEQUENT STEP]
  │
  └─► [OPTION 2]
          │
          ▼
      [FINAL STEP]
          │
          ▼
        END
```

## Flow Elements in Detail

### 1. Input Variables

| Variable Name | Data Type | Description | Required | Default |
|---------------|-----------|-------------|----------|---------|
| [variableName] | [Text/Id/Boolean/etc.] | [Description] | [Yes/No] | [Default value] |
| [variableName] | [Text/Id/Boolean/etc.] | [Description] | [Yes/No] | [Default value] |

### 2. [First Major Process Step]

**Operations**:
- [Detailed description of what happens in this step]
- [Data that is retrieved, queried, or manipulated]
- [Any special handling or edge cases]

**Decision Points** (if applicable):
- [Condition 1]: [Resulting path]
- [Condition 2]: [Resulting path]

**Formula** (if applicable):
```
[Formula expression]
```

### 3. [Second Major Process Step]

**Operations**:
- [Detailed description of what happens in this step]
- [Data that is retrieved, queried, or manipulated]
- [Any special handling or edge cases]

**Decision Points** (if applicable):
- [Condition 1]: [Resulting path]
- [Condition 2]: [Resulting path]

**Formula** (if applicable):
```
[Formula expression]
```

### 4. [Additional Steps as Needed]

[Follow the same pattern for all major steps in the flow]

## Error Handling

### Validation Rules

- [Description of validation 1]
- [Description of validation 2]

### Error Messages

| Error Scenario | Message | Resolution Path |
|----------------|---------|-----------------|
| [Scenario 1] | [Error message] | [What the flow does next] |
| [Scenario 2] | [Error message] | [What the flow does next] |

### Fault Paths

- **[Fault 1]**: [How the flow handles this fault]
- **[Fault 2]**: [How the flow handles this fault]

## Testing Considerations

### Prerequisites

- [Required setup 1]
- [Required setup 2]

### Test Scenarios

1. **[Scenario Name]**
   - **Input**: [Test input values]
   - **Expected Output**: [Expected result]
   - **Validation Method**: [How to verify success]

2. **[Scenario Name]**
   - **Input**: [Test input values]
   - **Expected Output**: [Expected result]
   - **Validation Method**: [How to verify success]

## Implementation Notes

- [Special configuration requirements]
- [Security considerations]
- [Performance considerations]
- [Limitations or constraints]

## Related Documents

- [Data model reference]
- [UI specifications if applicable]
- [Test cases document]
- [Integration points] 