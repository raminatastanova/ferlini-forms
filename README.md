# UsersForm

## Features

- **User Input Form**: Users can input their name, country, phone number, and email address.
- **Validation**: Input fields are validated to ensure correct data format.
- **Local Data Storage**: User data is saved locally using CoreData.
- **User List**: Displays a list of saved users.
- **Add New User**: Allows users to add new entries to the list.

## Installation

1. Clone the repository:

    ```bash
    git clone https://github.com/your_username/UsersForm.git
    ```

2. Open the project in Xcode:

    ```bash
    cd UsersForm
    open UsersForm.xcodeproj
    ```

3. Build and run the project in Xcode.

## Usage

1. Launch the app on your iOS device or simulator.
2. Fill in the required information in the user input form.
3. Tap the "Save" button to save the user data.
4. View the list of saved users in the user list.
5. Tap the "+" button to add a new user.

## Known issues

 - On the Form View with the selected user's information pre-filled, all information is displayed except for the Country.
     - Fix: Ensure the placeholder for the filled country is displayed and the picker opens only on tap.
      
 - On the Load Form View, the table is empty when you first open the application and if no user data has been saved.
     - Fix: Add a label to indicate that there are no saved users currently.
     
 - On the Form View, there is no alert indicating that the data was successfully saved.
     - Fix: Implement alerts/notifications for both failure and success cases.
