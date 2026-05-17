# UC-014 Teleport a Session to the Cloud

## Overview

- **ID**: UC-014
- **Name**: Teleport a Session to the Cloud
- **Primary Actor**: Developer
- **Goal**: Hand off the current local session to the Vibe Code cloud service so work can continue remotely.
- **Status**: Draft

## Preconditions

- A session is running.
- The teleport feature is available and enabled.
- The working directory is a Git repository.

## Main Success Scenario

1. The developer issues the teleport command.
2. The system checks that the working directory is a Git repository and gathers its details.
3. The system authenticates the developer with the cloud service.
4. The system packages the current session and repository context.
5. The system uploads the packaged session to the cloud workflow.
6. The system confirms that the session is now available in Vibe Code.

## Alternative Flows

- **A1 — Not a Git repository** (step 2): the directory is not under Git; the system reports that teleport requires a Git repository and stops.
- **A2 — Authentication required** (step 3): the developer is not yet authenticated; the system runs the cloud authentication flow before continuing.
- **A3 — Upload fails** (step 5): the cloud service returns an error; the system reports it and leaves the local session intact.

## Postconditions

- **Success**: The session is registered with the cloud service and can be continued remotely.
- **Failure**: The local session is unchanged and the failure is reported.

## Business Rules

- **BR-022**: Teleport requires the working directory to be a Git repository.

> Note: Teleport is gated behind a feature flag and is not exposed to all users; the flow above reflects the code path enabled by that flag.
