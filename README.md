# Mobile Repairing Application Prototype

This project is a Flutter-based mobile repairing application prototype. It features user and technician dashboards, authentication, repair request workflows, and a Q&A community (FixHub).

---

## Table of Contents
- [Class Diagram](#class-diagram)
- [Activity Diagram: User Sign Up & Login](#activity-diagram-user-sign-up--login)
- [Workflow Diagram: Repair Request](#workflow-diagram-repair-request)
- [Sequence Diagram: User Books Repair](#sequence-diagram-user-books-repair)
- [Technician Workflow](#technician-workflow)
- [Payment Workflow](#payment-workflow)
- [FixHub Q&A Workflow](#fixhub-qa-workflow)

---

## Class Diagram

```mermaid
classDiagram
    class User {
        int? id
        String name
        String email
        String password
        String phone
        String role
        +toMap()
        +toJson()
        +fromMap()
        +fromJson()
    }

    class AuthService {
        -DatabaseService _dbService
        +signUp()
        +login()
        +userExists()
    }

    class DatabaseService {
        +createUser()
        +getUserByEmail()
        +getRepairShops()
        +createAppointment()
        +getUserAppointments()
        +createQuestion()
        +getQuestions()
        +createAnswer()
        +getAnswersForQuestion()
        +updateQuestionUpvotes()
    }

    User <.. AuthService : uses
    AuthService <.. DatabaseService : uses
```

---

## Activity Diagram: User Sign Up & Login

```mermaid
flowchart TD
    A[Start] --> B[Open App]
    B --> C[Show Splash Screen]
    C --> D[Show Login/Signup Screen]
    D -->|Sign Up| E[Enter Details]
    E --> F[Call AuthService.signUp]
    F --> G{User Exists?}
    G -- Yes --> H[Show Error]
    G -- No --> I[Create User in DB]
    I --> J[Set Session]
    J --> K[Go to Dashboard]
    D -->|Login| L[Enter Credentials]
    L --> M[Call AuthService.login]
    M --> N{Credentials Valid?}
    N -- No --> H
    N -- Yes --> J
    K --> O[End]
```

---

## Workflow Diagram: Repair Request

```mermaid
flowchart TD
    A[User Dashboard] --> B[New Repair Request]
    B --> C[Fill Repair Details]
    C --> D[Submit Request]
    D --> E[Create Appointment in DB]
    E --> F[Assign Technician]
    F --> G[Technician Dashboard: View Appointment]
    G --> H[Technician Updates Status]
    H --> I[User Views Status]
    I --> J[Repair Completed]
```

---

## Sequence Diagram: User Books Repair

```mermaid
sequenceDiagram
    participant User
    participant LoginScreen
    participant AuthService
    participant DatabaseService
    participant SessionService
    participant UserDashboard

    User->>LoginScreen: Enter credentials
    LoginScreen->>AuthService: login(email, password)
    AuthService->>DatabaseService: getUserByEmail(email)
    DatabaseService-->>AuthService: userMap
    AuthService-->>LoginScreen: User object
    LoginScreen->>SessionService: setSession(User, role)
    SessionService-->>LoginScreen: Session set
    LoginScreen->>UserDashboard: Navigate to dashboard
```

---

## Technician Workflow

```mermaid
flowchart TD
    A[Technician Dashboard] --> B[View Today's Appointments]
    B --> C[Select Appointment]
    C --> D[View Repair Details]
    D --> E[Update Status: In Progress/Completed]
    E --> F[Add Notes/Parts Used]
    F --> G[Submit Update]
    G --> H[User Notified]
```

---

## Payment Workflow

```mermaid
flowchart TD
    A[Repair Completed] --> B[Generate Invoice]
    B --> C[Show Payment Options]
    C --> D{Payment Method}
    D -- Card/Online --> E[Process Payment]
    D -- Cash --> F[Mark as Paid]
    E --> G[Confirm Payment]
    F --> G
    G --> H[Update Repair Status: Paid]
    H --> I[Show Receipt to User]
```

---

## FixHub Q&A Workflow

```mermaid
flowchart TD
    A[User Dashboard] --> B[Open FixHub]
    B --> C[View Questions]
    C --> D[Ask Question]
    C --> E[Select Question]
    D --> F[Submit Question]
    E --> G[View Answers]
    G --> H[Add Answer]
    F --> I[Question Added]
    H --> J[Answer Added]
```

