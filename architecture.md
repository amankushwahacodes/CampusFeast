# Campus Food App Architecture

## Overview
A comprehensive campus food ordering app with wallet-based payments and vendor-specific discounts. The app serves students/staff as customers and canteen owners as vendors.

## Core Features (MVP)

### Student/Staff Features
1. **Authentication & Onboarding** - Email/phone verification with campus ID
2. **Digital Wallet** - Top-up, balance display, transaction history
3. **Vendor Discovery** - Browse canteens by location, status, ratings
4. **Menu & Ordering** - View items, apply discounts, cart management
5. **Order Tracking** - Real-time status updates (Placed → Preparing → Ready)
6. **Profile & History** - Order history, favorites, ratings

### Vendor Features
1. **Vendor Dashboard** - Sales overview, order management
2. **Menu Management** - Add/edit items, set prices, availability
3. **Order Processing** - Accept/reject orders, update status
4. **Discount Configuration** - Set wallet-based discounts
5. **Analytics** - Sales reports, popular items

## Technical Architecture

### File Structure (10 files total)
1. `main.dart` - App entry point and routing
2. `theme.dart` - Updated with food-centric colors
3. `models/` - Data models (User, Vendor, Order, MenuItem, etc.)
4. `screens/` - Main UI screens (Home, Menu, Cart, Profile, etc.)
5. `widgets/` - Reusable components
6. `services/` - Local storage and business logic
7. `utils/` - Constants and helpers

### Key Components
- **Bottom Navigation**: Home, Orders, Wallet, Profile
- **Home Screen**: Vendor discovery, search, categories
- **Menu Screen**: Items with discounts, add to cart
- **Cart & Checkout**: Apply discounts, wallet payment
- **Order Tracking**: Real-time status updates
- **Wallet Management**: Balance, top-up, history

### Data Storage
- **Local Storage**: User preferences, cart data, order history
- **Shared Preferences**: Authentication state, settings
- **Sample Data**: Realistic vendors, menus, and transactions

## Implementation Steps
1. Update theme with food-appropriate colors (orange/green palette)
2. Create data models for core entities
3. Implement authentication flow with role selection
4. Build main navigation and home screen
5. Create vendor discovery and menu browsing
6. Implement cart and checkout with wallet integration
7. Add order tracking and status management
8. Build vendor dashboard for order management
9. Add wallet management and transaction history
10. Compile and test the complete application

## Key Design Principles
- **Fast Navigation**: Bottom tabs for quick access
- **Visual Appeal**: Food imagery, clear pricing, discount highlights
- **User Experience**: Intuitive ordering flow, clear status indicators
- **Performance**: Efficient local storage, smooth animations
- **Accessibility**: Clear typography, good contrast, readable text sizes