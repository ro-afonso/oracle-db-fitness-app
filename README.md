# oracle-db-fitness-app
Creation of a database for a fitness app using Oracle SQL Developer.

Each user is identified by a UUID, a registration date, a service type (free or premium) and an activity label whose value changes when the user is online or offline.

Each user has a profile with their own physical characteristics, such as their weight, height, birth date, etc.

Each user also has several daily objectives, including the number of steps, burned calories, etc. 

The database has different types of exercises, such as running, walking, cycling and more, which affect different aspects, including the number of steps, calories, total distance, etc.

The exercises done by users are saved with their duration and respective variable values related to the exercise.

Each user can retrieve the data related with daily activity, including the date, steps, calories, weight and distance of each day. 

The payments of each user are also saved and identified with their UUID, date, value, etc. 

The previous elements and respective relationships are depicted below:

![Oracle DB Fitness Data Modeler](https://github.com/ro-afonso/oracle-db-fitness-app/assets/93609933/bfb5e810-697c-42fe-8003-abd458b7b679)

The database comprises the following functional requirements and procedures:
1) CRUD operations for users, profiles, daily objectives and exercise types
2) Set exercises done by each user
3) Set notifications to warn users every time a given parameter has a higher or lower value than the determined threshold, such as heart rate
4) Show the daily values for a user between different dates
5) Show the notifications of a user in the last 7 days
6) Show the users with a heart rate above or below the recommended threshold based on their age
7) Show the total amount paid by each user from a previous given date and until the current date
8) Show the non-active users, alongside their activity period and total paid value
9) Change and show each user's weight based on their diet and respective calories intake to promote healthy eating habits
