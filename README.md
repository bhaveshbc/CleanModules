 # CleanModules Movie App

Modular iOS Development • SwiftUI • Combine • Async/Await • Architecture

A showcase project demonstrating a **Redux-like architecture using a custom SwiftUI Property Wrapper**, paired with a **modular Swift Package structure** and **TMDB Movies API integration**.

---

## 🚀 Features

### 🧱 **Redux‑like State Management (without external libraries)**

* A custom `@MovieListStore` property wrapper powers state, actions, reducers, and async side effects.
* Clear unidirectional data flow inspired by Redux.
* `MoviesListState`, `MoviesListAction`, and `reduce()` replicate predictable state transitions.
* Supports **pull-to-refresh**, **pagination**, and **error handling**.

## 🧩 Project Architecture

This project follows a **modular architecture** using Swift Package Manager.

### **Modules Used**

| Module           | Responsibility                                       |
| ---------------- | ---------------------------------------------------- |
| **DesignKit**    | UI components, animations, loaders, spacing, styling |
| **APIClient**    | Network layer, routing, endpoints, request builder   |
| **ModelsKit**    | Codable DTOs, domain models                          |

Each module is isolated and reusable.

---

## 🎬 TMDB Movie API Integration

The app uses The Movie Database (**TMDB**) public API to fetch:

* **Today TV Shows**
* **Popular TV Shows**

---
![alt text](https://raw.githubusercontent.com/bhaveshbc/CleanModules/refs/heads/main/CleanModules/Resources/1.png)

<img src="https://raw.githubusercontent.com/bhaveshbc/CleanModules/refs/heads/main/CleanModules/Resources/1.png" width="200" height = "700"/>

## 🖥 SwiftUI Views


<img src="https://raw.githubusercontent.com/bhaveshbc/CleanModules/refs/heads/main/CleanModules/Resources/1.png" width="300" height = "600" style="margin-top:20px; margin-right:50px;"/>


<img src="https://raw.githubusercontent.com/bhaveshbc/CleanModules/refs/heads/main/CleanModules/Resources/2.png" width="300" height = "600" style="margin-right:50px;"/>




<img src="https://raw.githubusercontent.com/bhaveshbc/CleanModules/refs/heads/main/CleanModules/Resources/3.png" width="300" height = "600" style="margin-right:50px;"/>

<img src="https://raw.githubusercontent.com/bhaveshbc/CleanModules/refs/heads/main/CleanModules/Resources/4.png" width="300" height = "600" style="margin-top:50px; margin-right:50px;"/>

### **MovieList**

* Renders list of movies
* Handles pagination on `.onAppear`
* Includes pull-to-refresh support


---

## 📦 Setup Instructions

1. Clone the repository
2. Create a TMDB API key (free)
3. Replace the placeholder key inside service files:

```swift
"api_key": "YOUR_API_KEY_HERE"
```

4. Build & run

---

## 🏗 Possible Future Enhancements

* Add caching layer
* Add unit tests for reducers & services
* Add more TMDB endpoints
* Add navigation to movie details
* Introduce async sequences for streaming updates

---

## 📄 License

MIT — free to use, modify, and distribute.
