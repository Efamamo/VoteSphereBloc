# Database Design Documentation

## Overview

This document outlines the database design for VoteSphere, a collaborative voting application that allows
users to participate in polls within their groups. The database design focuses on managing users, groups,
polls, and poll options.

## Entities

### 1. User

- **Attributes:**
  - `Username` (Primary Key)
  - `Password`
  - `Role` (e.g., Admin, Member)
  - `TokenBlackList`
  - `groupID` (Foreign Key)

### 2. Group

- **Attributes:**
  - `GroupID` (Primary Key)
  - `GroupName`
  - `AdminUserID` (Foreign Key)

### 3. Poll

- **Attributes:**
  - `PollID` (Primary Key)
  - `Question`
  - `GroupID` (Foreign Key)
  - `IsOpen` (BOOLEAN)

### 4. PollOption

- **Attributes:**
  - `OptionID` (Primary Key)
  - `PollID` (Foreign Key)
  - `OptionText`
  - `NumberOfVotes`

## Relationships

- **User-Group Relationship:**

  - A User belongs to one Group.
  - A Group can have multiple Users.

- **Group-Admin Relationship:**

  - A Group is managed by one Admin User.

- **Poll-Group Relationship:**

  - A Poll belongs to one Group.
  - A Group can have multiple Polls.

- **PollOption-Poll Relationship:**
  - Each Poll can have multiple PollOptions(minimum of two).

## Data Types

- `UserID`: VARCHAR
- `Username`: VARCHAR
- `Password`: VARCHAR
- `Role`: VARCHAR
- `TokenBlackList`: LIST OF VARCHAR
- `GroupID`: VARCHAR
- `GroupName`: VARCHAR
- `AdminUserID`: VARCHAR
- `PollID`: VARCHAR
- `Question`: TEXT
- `IsOpen`: BOOLEAN
- `OptionID`: VARCHAR
- `OptionText`: VARCHAR
- `NumberOfVotes`: INT
