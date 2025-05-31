# 🧩 App: NestJS + Vue 3 + PostgreSQL + Docker

## 📦 Technologies

- **Backend:** [NestJS](https://nestjs.com/) + TypeScript
- **Frontend:** [Vue 3](https://vuejs.org/) + TypeScript + Vite
- **Database:** PostgreSQL
- **Containerization:** Docker + Docker Compose


## 📁 Structure

.
│
├── backend/
│ └── Dockerfile
│
├── frontend-admin/
│ └── Dockerfile
│
├── docker-compose.yml
└── README.md


## 🚀 Build & Run

### ✨ Clone repository

```bash
git clone https://github.com/your-username/your-repo.git
cd your-repo
```

### 🐳 Run with Docker

```bash
docker-compose up --build
```

- Hosts:
  - backend - http://localhost:3000/
  - frontend-admin - htttp://localhost/
  - database - localhost:5432