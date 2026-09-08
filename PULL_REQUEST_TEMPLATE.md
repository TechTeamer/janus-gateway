# Summary

| | |
| --- | --- |
| Description | TODO: Description |
| Related Ticket(s) | TODO: Ticket links |
| Related Documentation Plan | TODO: Link ([Template](https://docs.google.com/document/d/1WWYFgtJKf5HWnRIgZIoN7Vv50j8TR7YkcVsop_0a-G8/edit?usp=sharing)) or N/A |

## Reviewer Checklist

### 1. Technical Review

#### 1.1 Regression Analysis

- [ ] What other features might this affect?
- [ ] How could this feature be broken?
- [ ] How does the system behave in case of an error?
- [ ] What risk does faulty operation carry (e.g., data loss)?
- [ ] Could it affect the operation of other system components?

#### 1.2 Business Functionality (does it perform the task it was supposed to?)

- [ ] Has the functionality been implemented?
- [ ] Has deletion been considered and, where relevant, handled? E.g., if a customer/data record was deleted, what effect does that have, and is it handled?
- [ ] Has archiving been considered and, where relevant, handled? E.g., if a room/case was deleted, what effect does that have, and is it handled?
- [ ] In asynchronous/concurrent cases, are synchronization points coordinated?

#### 1.3 Integration, Public API (or any integration solution, e.g., queue, RPC, WebSocket, SSE, REST, SOAP, etc.)

- [ ] Has input validation been implemented and is it correct?
- [ ] Has it been considered from a security standpoint? E.g., is there authentication, throttling?
- [ ] Is the endpoint idempotent, where possible?
- [ ] Does the system handle duplicate events?
- [ ] Is there a correlation ID that runs through the entire request lifecycle?
- [ ] Is the API versioned? If it breaks backward compatibility, was the version incremented?

#### 1.4 Configuration, Changelog

- [ ] If it includes a configuration change, has it been carried through in both the `dev.json` and `docker.json` files, or at least considered?
- [ ] If there is a configuration change, it must also be made and regenerated in the documentation.
- [ ] Is anything that should be externally configurable actually configurable?
- [ ] Has the changelog been updated?

#### 1.5 Database

- [ ] Was a migration created? Does it migrate both up and down?
- [ ] Has it been tested with every supported database and every relevant version? (PostgreSQL, OracleDB, MSSQL, MySQL…)
- [ ] Have indexes been thought through?
- [ ] If it involves a large migration (typically the `attachment` table), has this been flagged so it can be accounted for at release time?
- [ ] Is the problem not being solved with an unnecessarily large number of operations?
- [ ] Is sensitive data stored encrypted?
- [ ] Soft delete instead of hard delete?
- [ ] Are there `created_at` and `updated_at` fields?

#### 1.6 Performance

- [ ] Is it sufficiently efficient — was performance considered? Something that works on 15 items may not work on 15 million. The possibility of large data volumes must be kept in mind.
- [ ] Streams and sockets are closed.
- [ ] Reasonable cyclomatic complexity.
- [ ] Is the timeout/retry logic reasonable?
- [ ] Is caching needed? If so, with what strategy?

#### 1.7 Observability, Error Handling, Maintainability

- [ ] Application logs placed in the code are in English, contain an identifier, and do not contain sensitive data (passwords, customer data…).
- [ ] Is the logging sufficient?
- [ ] It does not leave anything behind — e.g., temp files — either directly or via a cleanup mechanism (e.g., a cron job) ensuring cleanliness afterward.
- [ ] Is there a health check for every relevant component? (DB, queue, storage)
- [ ] Are possible errors handled?
- [ ] If it's a breaking change, is there a migration guide?

#### 1.8 Code Standards

- [ ] Lint produces no errors and no relevant warnings? E.g., unused variables, missing dependencies, language-specific issues…
- [ ] No formatting issues (e.g., indentation, overly long lines…)?
- [ ] Variable/function/class names are self-descriptive.
- [ ] No dead code.
- [ ] Is it commented? Comments are in English.
- [ ] No unnecessary comments (trivial or misleading).
- [ ] No unnecessary logging.
- [ ] No magic numbers.

### 2. Test Review

#### 2.1 Unit Tests

- [ ] Were unit tests created? If not, why not?
- [ ] Is everything covered?
- [ ] Existing tests extended where needed because of the new development.
- [ ] Are the tests reliable? (Not "flaky"?)

##### 2.2 End-to-End Tests

- [ ] Were end-to-end tests created? If not, why not?
- [ ] If yes, is everything covered?
- [ ] Existing tests extended where needed because of the new development.
- [ ] Are the tests reliable? (Not "flaky"?)

### 3. Documentation Review

- [ ] Has the README been updated, if necessary?

#### 3.1 Developer Documentation

- [ ] Was developer documentation created? If not, why not?
- [ ] Has documentation been added for every affected component?
- [ ] Was it written in English?
- [ ] Its location is within the codebase (in the given Git repository) — core documentation under `/docs`, customization-related documentation under `customization/docs`, in Markdown format ([Mermaid](https://mermaid.js.org/) can be used for diagrams).
- [ ] If it's a new feature, it belongs in a new sub-document; if it's a change to an existing one, an update was made instead.

#### 3.2 Integration Documentation

- [ ] Was integration documentation created? If not, why not?
- [ ] Has documentation been added for every affected component?
- [ ] Its language matches its location (English in code; may be Hungarian in partner-facing documentation).
- [ ] Its location in the code: `customization/docs/integration`.

#### 3.3 User Manual

- [ ] Was the user manual updated? If not, why not?
- [ ] Location: [User Manual](https://drive.google.com/drive/folders/11zJAfiScR1HgCpbybU4TNCcr_xZMQgT0?usp=drive_link)
- [ ] Business team involved for review/production purposes.
