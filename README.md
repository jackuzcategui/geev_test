# 📱 Tech Test iOS - Geev

Ce projet utilise **SwiftUI**, **UIKit**, et une architecture modulaire avec **MVVM + Coordinator + DI** (Injection de Dépendances). Voici un aperçu rapide du project.

---

## 🛠️ **Architecture**

- **MVVM (Model-View-ViewModel)** : Séparation claire des responsabilités pour la testabilité et la lisibilité.
- **Coordinator Pattern** : Gère la navigation de manière découplée.
- **Dependency Injection (DI)** : Utilisation de Swinject pour injecter les dépendances.
- **Modularité** : Chaque fonctionnalité (liste d'annonces et détail d'annonce) est un module séparé.
- **SnapKit** : Simplifie la creation des views sur UIKit.

---

## 📄 **Modules**

✅ **Core** (Liste des annonces)
- Dependency injection et protocol pour des coordinators.

✅ **Data** (Liste des annonces)
- Appels au API d'apres Alamofire.

✅ **AdListing Module** (Liste des annonces)
- Affichage des annonces dans une grille à deux colonnes (LazyVGrid).
- Prise en charge du pull-to-refresh.
- Pagination infinie avec gestion de l'état de chargement.

✅ **AdDetail Module** (Détail d'une annonce)
- Vue UIKit pour afficher l'image, le titre et la description.
- Binding réactif avec RxSwift pour UIKit.
- Version SwiftUI disponible via un UIViewControllerRepresentable.

---

## 🌐 **Réseau**

- Requêtes réseau avec Alamofire.
- Gestion des erreurs de requête et de décodage.
- AdRepository et AdDetailRepository assurent la séparation des couches de données.

---

## 🔄 **Navigation - Coordinators**

La navigation par SwiftUI est gérée par un **MainCoordinator**, qui utilise le **NavigationStack** en SwiftUI, et un **UIViewControllerRepresentable** pour le **AdDetailView**.

La navigation par UIKit est gérée par un **MainCoordinatorUIKit** avec un **UINavigationController**.

✅ **Changement de Coordinators**

Il y a un Button a l'écran principal qui permette basculer entre les deux Coordinators.

---

## 🧪 **Tests**

- Tests unitaires pour le service réseau (mock URLProtocol).
- Tests unitaires pour les viewModel de AdListing et AdDetail.
- Tests unitaires pour les "mapper" qui donnent la structure des donnés a chaque viewModel.

---

## 🙌 **Merci !**

Merci pour votre attention et l'opportunité de participer a ce procès.

Juan José Uzcátegui 