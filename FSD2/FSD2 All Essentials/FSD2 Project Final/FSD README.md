# Green Grocery
## FSD Project

Group Number - 30

## Get Started

The below steps show how to get started with the code running!.

★ Download git from the link:
https://git-scm.com/downloads.

★ Download node and npm from link
https://nodejs.org/en/.

★ After that in the terminal type ```pip install npm```.

★ Open the command prompt and run the command: 
```git clone https://github.com/fsd30/Green-Grocery```

★ We must now create two .env files in /client/ and /api/ folders.
  
★ In the client .env file:

- Create an environment variable "REACT_APP_STRIPE" and assign it your stripe account url for successful completion of payments.

★ In the api .env file:

- Create different variables with names as shown below 

  - MONGO_URL: For connecting to the MongoDB collection.
  - PASS_SEC = This is used for encrypting the password and can be named anything. 
  - JWT_SEC = This will be used for initialization of JWT Token and can be named anything as per convenience.
  - STRIPE_KEY= Here, the url of the stripe key must be provided.

★ Now, we have to install several dependencies.

- Change the directory to client Folder and enter the command ```yarn``` in the command line.
- Then, open another terminal and cd to the Admin Folder and enter the command ```yarn``` in the command line.
- Repeat this process for Volunteer and then API folder as well in different terminals and enter the command ```yarn``` in the command lines.

★ Finally to run the servers, use the following command
in all the terminals: ```yarn start```

★ Then, the terminal will prompt to open different URL's or else
enter the following URL's in your broweser for differenet pages.
- Enter http://localhost:3000/ for the frontend page (Client).
- Enter http://localhost:3001/ for the Admin Page.
- Enter http://localhost:3002/ for the Volunteer Page.

The API will run in the http://localhost:5000/ for the backend part and connceting to the MongoDB database.

★ After performing all the steps in correct order, the web application will start running smoothly. 

## Group Members

<pre>
Anirudh Jakhotia          - S20190010007
Neeraj Dusa               - S20190010047
Harish Mullagura          - S20190010124
Rakesh Ganeshula          - S20190010052
Kanduri Jayanth Sri Ram   - S20190010084
</pre>