
## Requirements

### Use Case Model 

 <p align="center" justify="center">
  <img src="../images/use-case-diagram.drawio.png">
  <p>Figure 1</p>
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

This section will contain the requirements of the product described as **user stories**, organized in a global **[user story map](https://plan.io/blog/user-story-mapping/)** with **user roles** or **themes**.

For each theme, or role, you may add a small description. User stories should be detailed in the tool you decided to use for project management (e.g. trello or github projects).

A user story is a description of desired functionality told from the perspective of the user or customer. A starting template for the description of a user story is

*As a < user role >, I want < goal > so that < reason >.*

**INVEST in good user stories**.
You may add more details after, but the shorter and complete, the better. In order to decide if the user story is good, please follow the [INVEST guidelines](https://xp123.com/articles/invest-in-good-stories-and-smart-tasks/).

**User interface mockups**.
After the user story text, you should add a draft of the corresponding user interfaces, a simple mockup or draft, if applicable.

**Acceptance tests**.
For each user story you should write also the acceptance tests (textually in [Gherkin](https://cucumber.io/docs/gherkin/reference/)), i.e., a description of scenarios (situations) that will help to confirm that the system satisfies the requirements addressed by the user story.

**Value and effort**.
At the end, it is good to add a rough indication of the value of the user story to the customers (e.g. [MoSCoW](https://en.wikipedia.org/wiki/MoSCoW_method) method) and the team should add an estimation of the effort to implement it, for example, using t-shirt sizes (XS, S, M, L, XL).



