## Requirements

### Use Case Model 

<p align="center" justify="center">
    <img src="../images/use-case-diagram.drawio.png">
</p>

|||
| --- | --- |
| *Name* | Check upcoming events |
| *Actor* |  FEUP Student |
| *Description* | The student wants to know in an organized manner upcoming tests, exams, assignment deadlines and their details |
| *Preconditions* | - The Student has signed-in into his/her account inside the app |
| *Postconditions* | - The Student finds out all the details of the upcoming events |
| *Normal flow* | 1. The student signs-in with his/her account <br> 2. The student accesses main menu page.<br> 3. The system fetches the data for this student<br> 2. The system shows the list of all upcoming events (ordered by date) <br> 3. The student selects an event to know further details <br> 4. The system shows all the detailed information about this event |
| *Alternative flows and exceptions* | 1. [Unable to Sign-in] If, the student for some reason is unable or does not want to sign-in, manual creation of events can also be done |

|||
| --- | --- |
| *Name* | Receive Notifications |
| *Actor* |  FEUP Student |
| *Description* | The students can receive notications without having to open the application |
| *Preconditions* | - The device which has the application installed, must have internet connection to sync events information<br> |
| *Postconditions* | - The Student gets notified about an event which is coming soon|
| *Normal flow* | 1. The system sends a notification when a new event is added/updated by the event proposer or when an event due date is near <br> 2. The Student receives an alert of the event on all devices that are connected associated with their account |
| *Alternative flows and exceptions* | 1. [No Internet Connection] The app cannot sync the events thus is not able to notify the user <br> 2. [Notification Details] If the Student wants to know further details about the notification, he/she can tap on the notification to automatically enter into the app and redirected to the details of the notification|

|||
| --- | --- |
| *Name* | Create an event |
| *Actor* |  Event Proposer (course teachers) | 
| *Description* |  The event proposer can create an event for a specific course |
| *Preconditions* | - The event proposer must have a teacher role in that specific course<br> |
| *Postconditions* | - The event notification is sent to all students that are applied to that specific course |
| *Normal flow* | 1. The event proposer opens the application and creates an event <br> 2. Details of this event can be added (such as event date, course associated, description, etc...) <br> 3. The event is posted and all the students that are applied to that course will receive a notification (see details on above)|
| *Alternative flows and exceptions* | 1. [Moodle Automatic Update] When an event is added in Moodle of an associated course, this one will also be automatically added to the application, and notification is also sent to the students |

|||
| --- | --- |
| *Name* | Update/remove an event |
| *Actor* |  Event Proposer (course teachers) | 
| *Description* |  The event proposer can update or remove an existing event for a specific course |
| *Preconditions* | - The event proposer must have a teacher role in that specific course<br> |
| *Postconditions* | - A notification is sent to all students that are applied to that specific course|
| *Normal flow* | 1. The event proposer opens the application and selects the event for update or removal <br> 2. A warning is showed before submission of this action and needs to be confirmed <br> 3. The changes are synced to all students interested in this event |
| *Alternative flows and exceptions* | 1. [Moodle Automatic Update] When an event is modified/removed in Moodle of an associated course, this one will also be automatically updated and removed from the application, and notification is also sent to the students |

### Domain Model

To better understand the context of the software system, it is very useful to have a simple UML class diagram with all the key concepts (names, attributes) and relationships involved of the problem domain addressed by your module. 
Also provide a short textual description of each class. 

Example:
 <p align="center" justify="center">
  <img src="../images/domain-model.drawio.png"/>
</p>

### User Stories

1. As a student, I want to receive deadline reminders for events that I am interested in, so that I won't miss any event.

2. As a student, I want to know if a teacher made changes to any event I'm interested in, so that I can reorganize my agenda according to the changes.

3. As a teacher, I want to be able to create an event whenever deemed necessary so that interested students can be notified and take action as soon as possible.

4. As a teacher, I want to be able to edit or update an event whenever deemed necessary so that the students can be notified and be aware as soon as possible.

5. As an app user, I want to see a list preview of all upcoming events, so that I can easily plan out my work schedule.

6. As an app user, I want to filter the events by date, so that I can easily find out all the upcoming events in a certain time window.

7. As an app user, I want to see all the detail about a event, so that I can have a better understanding of what the event is about.

8. As an app user, I want to be able to sign in to my account, so that I can have all my settings synchronised to the current device.

9. As an app user, I want to be able to recover my password, so that I can have a new password if I lose it or simply want to change it.

10. As an app user, I want to be able to have create an account, so that I can have all my settings synchronised across all my devices.

11. As an app user, I want to be able to choose the courses whose events I'm interested in, so that I only see and receive notifications for events I care about.

## User Story [1](https://github.com/LEIC-ES-2021-22/3LEIC01T1/issues/4)

As a student, I want to receive deadline reminders for events that I am interested in, so that I won't miss any event.

#### Mockup
 <p align="center" justify="center">
  <img src="../images/us1_mockup.png">
</p>

#### Acceptance Test
```gherkin
Given a event has a deadline in 24 hours or less,
When I turn on my phone screen,
Then I can read the notification and know brief information about it.
```

#### Value

Core Function

#### Effort

XL

## User Story [2](https://github.com/LEIC-ES-2021-22/3LEIC01T1/issues/5)

As a student, I want to know if a teacher made changes to any event I'm interested in, so that I can reorganize my agenda according to the changes.

#### Mockup
 <p align="center" justify="center">
  <img src="../images/us2_mockup.png">
</p>

#### Acceptance Test

```gherkin
Given that there was a change in an event and 'notify-event-updates' is enabled,
When I turn on my phone screen,
Then I can read the notification and know a brief detail about the change
```

#### Value

Important for many users 

#### Effort

M

## User Story [3](https://github.com/LEIC-ES-2021-22/3LEIC01T1/issues/6)

As a teacher, I want to be able to create an event whenever deemed necessary so that interested students can be notified and take action as soon as possible.

#### Mockup

<p align="center" justify="center">
  <img src="../images/us3_mockup.png">
</p>

#### Value

Core function 

#### Effort

XL

#### Acceptance Test

```gherkin
Given I am a teacher
When I click the New Event button
And I fill all required event information
Then an event is created
```

## User Story [4](https://github.com/LEIC-ES-2021-22/3LEIC01T1/issues/7)

As a teacher, I want to be able to edit or update an event whenever deemed necessary so that the students can be notified and be aware as soon as possible.

#### Mockup

<p align="center" justify="center">
  <img src="../images/us4_mockup.png">
</p>


#### Acceptance Test

```gherkin
Given I am a teacher and I want to edit or update an event
When I click the Edit Event button
And I edit the form fields I want
Then the event will be updated with new information
```

#### Value

Very important

#### Effort

L

## User Story [5](https://github.com/LEIC-ES-2021-22/3LEIC01T1/issues/8)

As an app user, I want to see a list preview of all upcoming events, so that I can easily plan out my work schedule.

#### Mockup

<p align="center" justify="center">
  <img src="../images/us5_mockup.png">
</p>

#### Acceptance Test

```gherkin
Given I want to see a preview of all my events,
When I head to the main menu,
Then a list of all events should show up
```

#### Value

Core function

#### Effort

XL

## User Story [6](https://github.com/LEIC-ES-2021-22/3LEIC01T1/issues/9)

As an app user, I want to filter the events by date, so that I can easily find out all the upcoming events in a certain time window.

#### Mockup

<p align="center" justify="center">
  <img src="../images/us6_mockup.png">
</p>

#### Acceptance Test

```gherkin
Given I want to see events with deadlines within selected timewindow,
When I open the sidebar and choose a time filter,
Then a filtered list of events should show up.
```

#### Value

Secondary feature

#### Effort

S

## User Story [7](https://github.com/LEIC-ES-2021-22/3LEIC01T1/issues/10):

As an app user, I want to see all the detail about a event, so that I can have a better understanding of what the event is about.

#### Mockup

<p align="center" justify="center">
  <img src="../images/us7_mockup.png">
</p>

#### Acceptance Test

```gherkin
Given I want to know all the details about an event,
When I click on an event in a section with events,
Then I should see a page with all the details of the selected event
```

#### Value

Very important

#### Effort

L

## User Story [8](https://github.com/LEIC-ES-2021-22/3LEIC01T1/issues/11):

As an app user, I want to be able to sign in to my account, so that I can have all my settings synchronised to the current device.

#### Mockup

<p align="center" justify="center">
  <img src="../images/us8_mockup.png">
</p>

#### Acceptance Test

```gherkin
Given I want to have my settings on this device
When I open the application and I'm not already authenticated
Then a window should appear to log in with my credentials
```

#### Value

Core function

#### Effort

XL

## User Story [9](https://github.com/LEIC-ES-2021-22/3LEIC01T1/issues/12):

As an app user, I want to be able to recover my password, so that I can have a new password if I lose it or simply want to change it.

#### Mockup

<p align="center" justify="center">
  <img src="../images/us8_mockup.png">
</p>

#### Acceptance Test

```gherkin
Given I want to recover the password,
When I click on 'forgot your password?'
Then a form should show up to recover or change my password
```

#### Value

Useful but secondary function

#### Effort

M


## User Story [10](https://github.com/LEIC-ES-2021-22/3LEIC01T1/issues/16)

As an app user, I want to be able to have create an account, so that I can have all my settings synchronised across all my devices.

#### Mockup

<p align="center" justify="center">
  <img src="../images/us10_mockup.png">
</p>

#### Acceptance Test

```gherkin
Given I want to have the same settings on all my devices
When I'm not already authenticated and I click the sign up button
Then a Sign Up window should appear
```

#### Value

Core function

#### Effort

XL


## User Story [11](https://github.com/LEIC-ES-2021-22/3LEIC01T1/issues/17)

As an app user, I want to be able to choose the courses whose events I'm interested in, so that I only see and receive notifications for events I care about.

#### Mockup

<p align="center" justify="center">
  <img src="../images/us11_mockup.png">
</p>

#### Acceptance Test

```gherkin
Given I'm only in certain courses' events
When I click the courses page
And I select the courses I'm interested in
Then the selected courses should be saved in my settings
```

#### Value

Core function

#### Effort

XL