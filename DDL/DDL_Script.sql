CREATE TABLE Users(
    User_ID VARCHAR(255) NOT NULL,
    User_Name VARCHAR(255) NOT NULL,
    First_Name VARCHAR(255) NOT NULL,
    Middle_Name VARCHAR(255) NOT NULL,
    Last_name VARCHAR(255) NOT NULL,
    DOB DATE NOT NULL,
    Phone_No BIGINT NOT NULL,
    Email_ID VARCHAR(255) NOT NULL,
    Address TEXT NOT NULL,
    City VARCHAR(255) NOT NULL,
    Country VARCHAR(255) NOT NULL,
    Headline TEXT,
    Registration_Date DATE NOT NULL,
    PRIMARY KEY(User_ID)
);

CREATE TABLE Institute(
    Institute_ID VARCHAR(255) NOT NULL,
    Institute_Name VARCHAR(255) NOT NULL,
    City VARCHAR(255) NOT NULL,
    Country VARCHAR(255) NOT NULL,
    About TEXT NOT NULL,
    PRIMARY KEY(Institute_ID)
); 

CREATE TABLE Education(
    Education_ID VARCHAR(255) NOT NULL,
    User_ID VARCHAR(255) NOT NULL,
    Institue_ID VARCHAR(255) NOT NULL,
    Degree VARCHAR(255) NOT NULL,
    Grade DECIMAL(8, 2) NOT NULL,
    Start_Date DATE NOT NULL,
    End_Date DATE NOT NULL,
    Field_Of_Study VARCHAR(255) NOT NULL,
    Description TEXT,
    PRIMARY KEY(Education_ID),
    FOREIGN KEY(User_ID) REFERENCES Users(User_ID),
    FOREIGN KEY(Institue_ID) REFERENCES Institute(Institute_ID)
);


CREATE TABLE Skill(
    Skill_Name VARCHAR(255) NOT NULL,
    PRIMARY KEY(Skill_Name)
);


CREATE TABLE Skill_From_Edu(
    Education_ID VARCHAR(255) NOT NULL,
    Skill_Name VARCHAR(255) NOT NULL,
    PRIMARY KEY(Education_ID,Skill_Name),
    FOREIGN KEY(Skill_Name) REFERENCES Skill(Skill_Name),
    FOREIGN KEY(Education_ID) REFERENCES Education(Education_ID)
);


CREATE TABLE User_Skill(
    Skill_Name VARCHAR(255) NOT NULL,
    User_ID VARCHAR(255) NOT NULL,
    PRIMARY KEY(Skill_Name,User_ID),
    FOREIGN KEY(Skill_Name) REFERENCES Skill(Skill_Name),
    FOREIGN KEY(User_ID) REFERENCES Users(User_ID)
);

CREATE TABLE Skill_Endorsed_By(
    Skill_Name VARCHAR(255) NOT NULL REFERENCES Skill(Skill_Name),
    User_ID VARCHAR(255) NOT NULL REFERENCES Users(User_ID),
    Endorsed_From VARCHAR(255) NOT NULL REFERENCES Users(User_ID),
    PRIMARY KEY(Skill_Name,User_ID,Endorsed_From),
    FOREIGN KEY(Skill_Name,User_ID) REFERENCES User_Skill(Skill_Name,User_ID)
);



CREATE TABLE Company(
    CIN_No VARCHAR(255) NOT NULL,
    Company_Name VARCHAR(255) NOT NULL,
    Hiring_Status BOOLEAN DEFAULT FALSE,
    City VARCHAR(255) NOT NULL,
    State VARCHAR(255) NOT NULL,
    About TEXT NOT NULL,
    PRIMARY KEY(CIN_No)
);



CREATE TABLE Company_Followers(
    User_ID VARCHAR(255) NOT NULL,
    CIN_No VARCHAR(255) NOT NULL,
    PRIMARY KEY(User_ID,CIN_No),
    FOREIGN KEY(User_ID) REFERENCES Users(User_ID),
    FOREIGN KEY(CIN_No) REFERENCES Company(CIN_No)
);

CREATE TABLE Experience(
    Experience_ID VARCHAR(255) NOT NULL,
    User_ID VARCHAR(255) NOT NULL,
    CIN_No VARCHAR(255) NOT NULL,
    Experience_Field VARCHAR(255) NOT NULL,
    Start_Date DATE NOT NULL,
    End_Date DATE NOT NULL,
    Description TEXT,
    PRIMARY KEY(Experience_ID),
    FOREIGN KEY(User_ID) REFERENCES Users(User_ID),
    FOREIGN KEY(CIN_No) REFERENCES Company(CIN_No)
);



CREATE TABLE Skill_From_Exp(
    Experience_ID VARCHAR(255) NOT NULL,
    Skill_Name VARCHAR(255) NOT NULL,
    PRIMARY KEY(Experience_ID,Skill_Name),
    FOREIGN KEY(Experience_ID) REFERENCES Experience(Experience_ID),
    FOREIGN KEY(Skill_Name) REFERENCES Skill(Skill_Name)
);



CREATE TABLE Groups(
    Group_ID VARCHAR(255) NOT NULL,
    Group_Name VARCHAR(255) NOT NULL,
    PRIMARY KEY(Group_ID)
);



CREATE TABLE Group_Members(
    Group_ID VARCHAR(255) NOT NULL,
    User_ID VARCHAR(255) NOT NULL,
    Is_Leader BOOLEAN DEFAULT FALSE,
    PRIMARY KEY(Group_ID,User_ID),
    FOREIGN KEY(Group_ID) REFERENCES Groups(Group_ID),
    FOREIGN KEY(User_ID) REFERENCES Users(User_ID)
);


CREATE TABLE Offered_Jobs(
    Job_Role VARCHAR(255) NOT NULL,
    CIN_No VARCHAR(255) NOT NULL,
    Job_Description TEXT NOT NULL,
    Vacancy BIGINT NOT NULL,
    Last_Date_To_Apply DATE NOT NULL,
    PRIMARY KEY(Job_Role,CIN_No),
    FOREIGN KEY(CIN_No) REFERENCES Company(CIN_No)
);



CREATE TABLE Looks_For(
    User_ID VARCHAR(255) NOT NULL,
    Job_Role VARCHAR(255) NOT NULL,
  	CIN_No VARCHAR(255) NOT NULL,
    PRIMARY KEY(User_ID,Job_Role,CIN_No),
    FOREIGN KEY(User_ID) REFERENCES Users(User_ID),
    FOREIGN KEY(Job_Role,CIN_No) REFERENCES Offered_Jobs(Job_Role,CIN_No)
);



CREATE TABLE Request(
    Sent_By_UID VARCHAR(255) NOT NULL,
    Sent_To_UID VARCHAR(255) NOT NULL,
    Sent_Date DATE NOT NULL,
    Status VARCHAR(255) NOT NULL,
    PRIMARY KEY(Sent_By_UID,Sent_To_UID),
    FOREIGN KEY(Sent_By_UID) REFERENCES Users(User_ID),
    FOREIGN KEY(Sent_To_UID) REFERENCES Users(User_ID)
);


CREATE TABLE Certificates(
    Credential_ID VARCHAR(255) NOT NULL,
    User_ID VARCHAR(255) NOT NULL,
    Certificate_Name VARCHAR(255) NOT NULL,
    Issue_Date DATE NOT NULL,
    Issuing_Org VARCHAR(255) NOT NULL,
    Expiration_Date DATE NOT NULL,
    PRIMARY KEY(Credential_ID),
    FOREIGN KEY(User_ID) REFERENCES Users(User_ID)
);


CREATE TABLE Post(
    Post_ID VARCHAR(255) NOT NULL,
    User_ID VARCHAR(255) NOT NULL,
    Created_Date DATE DEFAULT CURRENT_DATE,
    Updated_Date DATE DEFAULT CURRENT_DATE,
    Description TEXT NOT NULL,
    PRIMARY KEY(Post_ID),
    FOREIGN KEY(User_ID) REFERENCES Users(User_ID)
);

CREATE TABLE Comment(
    Comment_ID VARCHAR(255) NOT NULL,
    Post_ID VARCHAR(255) NOT NULL,
    User_ID VARCHAR(255) NOT NULL,
    Description TEXT NOT NULL,
    Commented_Date DATE DEFAULT CURRENT_DATE,
    Updated_Date DATE DEFAULT CURRENT_DATE,
    PRIMARY KEY(Comment_ID),
    FOREIGN KEY(User_ID) REFERENCES Users(User_ID),
    FOREIGN KEY(Post_ID) REFERENCES Post(Post_ID)
);