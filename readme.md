# 🧩 App: NestJS + Vue 3 + PostgreSQL + Docker

## 📦 Technologies

- **Backend:** [NestJS](https://nestjs.com/) + TypeScript
- **Frontend:** [Vue 3](https://vuejs.org/) + TypeScript + Vite
- **Database:** PostgreSQL
- **Containerization:** Docker + Docker Compose


## 📁 Structure
```text
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
```


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
  - frontend-admin - htttp://localhost:80/
  - database - localhost:5432


### 🚀 Run app

Run Backend for development
```bash
npm run start:dev
```

Run Backend for production
```bash
npm run start:prod
```

Run Frontend for development
```bash
npm run dev
```

Run Frontend for production
```bash
npm run build
```
  

### 🚀 Run on PHP production server

Install process manager to run app in background
```bash
npm install pm2
```

Run using process manager
```bash
cd backend
pm2 start npm --name backend -- run start:prod
```

Stop background processes
```bash
pm2 stop all
```