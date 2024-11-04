# Nightwind

Nightwind is a **forum-based** application designed to provide an engaging, community-driven experience on iOS.
The app allows users to create and participate in discussions over posts, upvote or downvote posts and replies. 
The backend is powered by Spring Boot and MariaDB, with a REST API over JWT-based authentication.

## Features

Nightwind's functionality is organized into three main entities:

> ### Posts:
> - Title
> - Content
> - Media (optional)
> - Author
> - Upvote/Downvote
> - Discussions

> ### Discussions:
> - Content
> - Author
> - Upvote/Downvote
> - Nested replies (threaded discussions)

> ### Authors:
> - Username
> - Avatar
> - Posts
> - Discussions

**he iOS app provides a streamlined and accessible interface to explore, create, and interact with forum content.*

## Architecture

### iOS Application [`ios/`](./ios/)

#### Intuitive UI

The iOS application is built using **UIKit** (and little SwiftUI).

With distinct sections for **Feed**, **Posts**, **Discussions**, **Author Pages**, and **Authentication**.

#### Strong architecture pattern

It follows the **MVVM** architecture to maintain clear separation between the user interface, data, and operative logic. 

The **Moya** library is used to handle network requests to the backend API easily.

### Backend [`server/`](./server/)

The backend, developed with **Spring Boot** and **MariaDB**, provides a RESTful API to serve the forum data to the iOS client. 
The server is configured for scalability and includes JWT-based authorization for secure access control.

For API documentation, refer to the Swagger specification: [API Documentation](https://rx.ermnvldmr.com/swagger-ui/index.html#/)

## Design

Nightwind is built with a **clean**, **light** design aesthetic that prioritizes **simplicity** and **readability**. 
We leverage [Material Design icons](https://github.com/google/material-design-icons) for consistent, intuitive visuals across the app. 
The color scheme is based on a [rainby](https://github.com/deytenit/Rainby/blob/main/pallete.pdf) theme, giving the app a vibrant, friendly look while keeping interactions smooth and engaging.

Overall solution avaliable for *the chosen ones* on figma,
but you can peak a little at [Nightwind Design](https://www.figma.com/design/Jsu174WLgBmIfJzWWpL6GF/Nightwind?node-id=1-16&t=1229I7KRGAHMdraV-1)

## Colaboration

Main communication goes over **Telegram Chat** and **Google Meet**.

We're using **Trello** for task management.

*(If you wish to access them - contact one of the contributors)*

## Postface

Copyright (c) Nightwind Development Team
