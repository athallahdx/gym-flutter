# Gym Management System API Documentation

## Overview
Comprehensive API untuk sistem manajemen gym yang mencakup manajemen user, membership, kelas gym, personal trainer, kunjungan gym, dan pembayaran.

## Base URL
```
https://yourdomain.com/api/v1
```

## Authentication
API menggunakan Laravel Sanctum untuk autentikasi. Setelah login, gunakan Bearer token untuk mengakses endpoint yang dilindungi.

```
Authorization: Bearer {your-token}
```

## Response Format
Semua response menggunakan format JSON dengan struktur standar:

### Success Response
```json
{
    "status": "success",
    "message": "Operation successful",
    "data": {...}
}
```

### Error Response
```json
{
    "status": "error",
    "message": "Error description",
    "errors": {...} // Untuk validation errors
}
```

## Endpoints

### Authentication

#### POST /register
Registrasi user baru
```json
{
    "name": "John Doe",
    "email": "john@example.com",
    "password": "password123",
    "password_confirmation": "password123",
    "phone": "081234567890",
    "profile_bio": "Fitness enthusiast",
    "profile_image": "file upload"
}
```

#### POST /login
Login user
```json
{
    "email": "john@example.com",
    "password": "password123"
}
```

#### POST /logout
Logout user (authenticated)

#### GET /profile
Get user profile (authenticated)

#### PUT /profile
Update user profile (authenticated)

#### POST /change-password
Change password (authenticated)

### User Management

#### GET /users
Get all users (admin only)
Parameters: `role`, `membership_status`, `search`, `per_page`

#### GET /users/{id}
Get specific user

#### POST /users
Create new user (admin only)

#### PUT /users/{id}
Update user (admin or own profile)

#### DELETE /users/{id}
Delete user (admin only)

#### GET /users-statistics
Get user statistics (admin only)

#### GET /trainers-list
Get list of trainers

### Membership Management

#### GET /membership/packages
Get all membership packages
Parameters: `status`, `search`, `sort_by`, `sort_order`, `per_page`

#### GET /membership/packages/{id}
Get specific membership package

#### POST /membership/packages
Create membership package (admin only)

#### PUT /membership/packages/{id}
Update membership package (admin only)

#### DELETE /membership/packages/{id}
Delete membership package (admin only)

#### GET /membership/my-memberships
Get user's membership history

#### GET /membership/current
Get current active membership

#### POST /membership/purchase
Purchase membership package

#### GET /membership/all
Get all memberships (admin only)

#### PUT /membership/status/{id}
Update membership status (admin only)

#### GET /membership/statistics
Get membership statistics (admin only)

### Gym Classes Management

#### GET /gym-classes
Get all gym classes
Parameters: `status`, `search`, `sort_by`, `sort_order`, `per_page`

#### GET /gym-classes/{id}
Get specific gym class

#### POST /gym-classes
Create gym class (admin only)

#### PUT /gym-classes/{id}
Update gym class (admin only)

#### DELETE /gym-classes/{id}
Delete gym class (admin only)

#### GET /gym-classes/{classId}/schedules
Get class schedules
Parameters: `start_date`, `end_date`, `per_page`

#### POST /gym-classes/{classId}/schedules
Create class schedule (admin only)

#### PUT /gym-classes/{classId}/schedules/{scheduleId}
Update class schedule (admin only)

#### DELETE /gym-classes/{classId}/schedules/{scheduleId}
Delete class schedule (admin only)

#### POST /gym-classes/book
Book class session
```json
{
    "gym_class_id": 1,
    "gym_class_schedule_id": 1
}
```

#### DELETE /gym-classes/bookings/{attendanceId}
Cancel class booking

#### GET /gym-classes/my-bookings
Get user's class bookings

#### PUT /gym-classes/attendance/{attendanceId}
Mark attendance (admin only)

#### GET /gym-classes/statistics
Get class statistics (admin only)

### Personal Trainer Management

#### GET /trainers
Get all personal trainers
Parameters: `search`, `per_page`

#### GET /trainers/{id}
Get specific personal trainer

#### POST /trainers
Create personal trainer profile (admin only)

#### PUT /trainers/{id}
Update personal trainer profile

#### DELETE /trainers/{id}
Delete personal trainer (admin only)

#### GET /trainer-packages
Get trainer packages
Parameters: `status`, `search`, `per_page`

#### GET /trainer-packages/{id}
Get specific trainer package

#### GET /trainers/{trainerId}/packages
Get specific trainer's packages

#### POST /trainers/packages
Create trainer package

#### PUT /trainers/packages/{packageId}
Update trainer package

#### DELETE /trainers/packages/{packageId}
Delete trainer package

#### POST /trainers/packages/purchase
Purchase trainer package

#### GET /trainers/assignments
Get trainer assignments

#### GET /trainers/{trainerId}/assignments
Get specific trainer's assignments

#### GET /trainers/assignments/{assignmentId}
Get specific assignment

#### GET /trainers/schedules
Get trainer schedules

#### GET /trainers/{trainerId}/schedules
Get specific trainer's schedules

#### POST /trainers/schedules
Create training schedule

#### PUT /trainers/schedules/{scheduleId}
Update training schedule

#### GET /trainers/statistics
Get trainer statistics

#### GET /trainers/{trainerId}/statistics
Get specific trainer's statistics

### Gym Visits Management

#### GET /gym-visits
Get all gym visits (admin only)
Parameters: `user_id`, `status`, `start_date`, `end_date`, `search`, `per_page`

#### GET /gym-visits/my-visits
Get user's own gym visits

#### GET /gym-visits/{id}
Get specific gym visit

#### POST /gym-visits/check-in
Check in to gym

#### POST /gym-visits/check-out
Check out from gym

#### GET /gym-visits/status/current
Get current visit status

#### POST /gym-visits/manual-entry
Manual check-in/out by admin

#### PUT /gym-visits/{id}
Update gym visit (admin only)

#### DELETE /gym-visits/{id}
Delete gym visit (admin only)

#### GET /gym-visits/statistics/admin
Get visit statistics (admin only)

#### GET /gym-visits/statistics/my-stats
Get user's visit statistics

### Payment & Transactions

#### GET /payments/transactions
Get all transactions (admin only)
Parameters: `payment_status`, `purchasable_type`, `user_id`, `start_date`, `end_date`, `search`, `per_page`

#### GET /payments/my-transactions
Get user's own transactions

#### GET /payments/transactions/{id}
Get specific transaction

#### POST /payments/membership
Purchase membership package
```json
{
    "membership_package_id": 1
}
```

#### POST /payments/gym-class
Purchase gym class
```json
{
    "gym_class_id": 1,
    "gym_class_schedule_id": 1
}
```

#### POST /payments/trainer-package
Purchase trainer package
```json
{
    "personal_trainer_package_id": 1
}
```

#### POST /payments/notification
Handle payment notification from Midtrans (webhook)

#### GET /payments/status/{transactionId}
Check payment status

#### POST /payments/cancel/{transactionId}
Cancel transaction

#### POST /payments/manual-approval/{transactionId}
Manual payment approval (admin only)

#### GET /payments/statistics
Get payment statistics (admin only)

## Error Codes

- `200` - OK
- `201` - Created
- `400` - Bad Request
- `401` - Unauthorized
- `403` - Forbidden
- `404` - Not Found
- `422` - Unprocessable Entity (Validation Error)
- `500` - Internal Server Error

## Rate Limiting
API memiliki rate limiting untuk mencegah abuse. Default limit adalah 60 requests per minute per user.

## File Upload
Untuk endpoint yang menerima file upload, gunakan `multipart/form-data` content type.

Supported image formats: `jpeg`, `png`, `jpg`, `gif`
Maximum file size: `2MB`

## Pagination
Endpoint yang mengembalikan list data menggunakan pagination dengan format:

```json
{
    "status": "success",
    "data": {
        "current_page": 1,
        "data": [...],
        "first_page_url": "...",
        "from": 1,
        "last_page": 5,
        "last_page_url": "...",
        "next_page_url": "...",
        "path": "...",
        "per_page": 15,
        "prev_page_url": null,
        "to": 15,
        "total": 67
    }
}
```

## Examples

### Complete User Registration and Membership Purchase Flow

1. **Register User**
```bash
curl -X POST "https://yourdomain.com/api/v1/register" \
-H "Content-Type: application/json" \
-d '{
    "name": "John Doe",
    "email": "john@example.com",
    "password": "password123",
    "password_confirmation": "password123",
    "phone": "081234567890"
}'
```

2. **Login**
```bash
curl -X POST "https://yourdomain.com/api/v1/login" \
-H "Content-Type: application/json" \
-d '{
    "email": "john@example.com",
    "password": "password123"
}'
```

3. **Get Membership Packages**
```bash
curl -X GET "https://yourdomain.com/api/v1/membership/packages" \
-H "Authorization: Bearer {token}"
```

4. **Purchase Membership**
```bash
curl -X POST "https://yourdomain.com/api/v1/payments/membership" \
-H "Authorization: Bearer {token}" \
-H "Content-Type: application/json" \
-d '{
    "membership_package_id": 1
}'
```

5. **Check In to Gym**
```bash
curl -X POST "https://yourdomain.com/api/v1/gym-visits/check-in" \
-H "Authorization: Bearer {token}"
```

### Trainer Management Flow

1. **Get Available Trainers**
```bash
curl -X GET "https://yourdomain.com/api/v1/trainers" \
-H "Authorization: Bearer {token}"
```

2. **Get Trainer Packages**
```bash
curl -X GET "https://yourdomain.com/api/v1/trainer-packages" \
-H "Authorization: Bearer {token}"
```

3. **Purchase Trainer Package**
```bash
curl -X POST "https://yourdomain.com/api/v1/payments/trainer-package" \
-H "Authorization: Bearer {token}" \
-H "Content-Type: application/json" \
-d '{
    "personal_trainer_package_id": 1
}'
```

4. **Create Training Schedule**
```bash
curl -X POST "https://yourdomain.com/api/v1/trainers/schedules" \
-H "Authorization: Bearer {token}" \
-H "Content-Type: application/json" \
-d '{
    "personal_trainer_assignment_id": 1,
    "scheduled_at": "2024-01-15 10:00:00",
    "status": "scheduled"
}'
```

## Notes

- Semua timestamp dalam format ISO 8601 (YYYY-MM-DD HH:MM:SS)
- Tanggal dalam format YYYY-MM-DD
- Waktu dalam format HH:MM
- Semua amount/price dalam format integer (cents/satoshi)
- File upload maksimal 2MB
- API mendukung CORS untuk frontend integration

## Support

Untuk pertanyaan atau masalah terkait API, silakan hubungi tim development.