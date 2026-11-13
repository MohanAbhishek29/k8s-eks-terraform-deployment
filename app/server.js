const express = require('express');
const os = require('os');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());

// In-memory Task store (initial seed data)
let tasks = [
  { id: 1, title: 'Provision AWS VPC & Subnets with Terraform', category: 'Infrastructure', completed: true },
  { id: 2, title: 'Deploy EKS Managed Node Group (t3.medium)', category: 'Kubernetes', completed: true },
  { id: 3, title: 'Deploy Microservice Deployment & LoadBalancer Service', category: 'Application', completed: true },
  { id: 4, title: 'Record Ephemeral Demo & Teardown Architecture', category: 'DevOps', completed: false }
];

let nextId = 5;

// Healthcheck endpoint for Kubernetes liveness & readiness probes
app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'HEALTHY',
    timestamp: new Date().toISOString(),
    pod: os.hostname(),
    uptime: `${Math.floor(process.uptime())}s`
  });
});

// REST API Endpoints
app.get('/api/tasks', (req, res) => {
  res.json({
    pod: os.hostname(),
    count: tasks.length,
    data: tasks
  });
});

app.post('/api/tasks', (req, res) => {
  const { title, category } = req.body;
  if (!title) {
    return res.status(400).json({ error: 'Title is required' });
  }

  const newTask = {
    id: nextId++,
    title,
    category: category || 'General',
    completed: false
  };

  tasks.push(newTask);
  res.status(201).json({
    message: 'Task created successfully',
    task: newTask,
    servedByPod: os.hostname()
  });
});

app.patch('/api/tasks/:id', (req, res) => {
  const taskId = parseInt(req.params.id, 10);
  const task = tasks.find(t => t.id === taskId);

  if (!task) {
    return res.status(404).json({ error: 'Task not found' });
  }

  if (typeof req.body.completed === 'boolean') {
    task.completed = req.body.completed;
  }
  if (req.body.title) {
    task.title = req.body.title;
  }

  res.json({ message: 'Task updated', task, servedByPod: os.hostname() });
});

app.delete('/api/tasks/:id', (req, res) => {
  const taskId = parseInt(req.params.id, 10);
  const initialLength = tasks.length;
  tasks = tasks.filter(t => t.id !== taskId);

  if (tasks.length === initialLength) {
    return res.status(404).json({ error: 'Task not found' });
  }

  res.json({ message: 'Task deleted', servedByPod: os.hostname() });
});

// Interactive Web UI for the LoadBalancer Demo Screen Recording
app.get('/', (req, res) => {
  const currentPod = os.hostname();
  const uptime = Math.floor(process.uptime());

  res.send(`<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>AWS EKS Ephemeral Microservice</title>
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
      background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);
      color: #f8fafc;
      min-height: 100vh;
      display: flex;
      justify-content: center;
      align-items: center;
      padding: 20px;
    }
    .container {
      width: 100%;
      max-width: 800px;
      background: rgba(30, 41, 59, 0.7);
      backdrop-filter: blur(12px);
      border: 1px solid rgba(255, 255, 255, 0.1);
      border-radius: 16px;
      padding: 32px;
      box-shadow: 0 20px 40px rgba(0, 0, 0, 0.4);
    }
    .header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      border-bottom: 1px solid rgba(255, 255, 255, 0.1);
      padding-bottom: 20px;
      margin-bottom: 24px;
    }
    .badge {
      display: inline-flex;
      align-items: center;
      gap: 6px;
      padding: 6px 12px;
      background: rgba(16, 185, 129, 0.2);
      border: 1px solid rgba(16, 185, 129, 0.4);
      color: #34d399;
      border-radius: 9999px;
      font-size: 13px;
      font-weight: 600;
    }
    .pulse {
      width: 8px;
      height: 8px;
      background: #10b981;
      border-radius: 50%;
      box-shadow: 0 0 10px #10b981;
    }
    .meta-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
      gap: 16px;
      margin-bottom: 28px;
    }
    .meta-card {
      background: rgba(15, 23, 42, 0.6);
      border: 1px solid rgba(255, 255, 255, 0.05);
      border-radius: 10px;
      padding: 14px 18px;
    }
    .meta-label { font-size: 12px; color: #94a3b8; text-transform: uppercase; letter-spacing: 0.05em; }
    .meta-value { font-size: 15px; font-weight: 600; color: #38bdf8; margin-top: 4px; word-break: break-all; }
    .task-form {
      display: flex;
      gap: 10px;
      margin-bottom: 24px;
    }
    input[type="text"] {
      flex: 1;
      padding: 12px 16px;
      border-radius: 8px;
      border: 1px solid rgba(255, 255, 255, 0.15);
      background: rgba(15, 23, 42, 0.8);
      color: white;
      font-size: 14px;
      outline: none;
    }
    input[type="text"]:focus { border-color: #38bdf8; }
    button {
      padding: 12px 20px;
      border-radius: 8px;
      border: none;
      background: #0284c7;
      color: white;
      font-weight: 600;
      cursor: pointer;
      transition: background 0.2s;
    }
    button:hover { background: #0369a1; }
    .task-list { list-style: none; display: flex; flex-direction: column; gap: 10px; }
    .task-item {
      display: flex;
      justify-content: space-between;
      align-items: center;
      background: rgba(15, 23, 42, 0.4);
      padding: 12px 16px;
      border-radius: 8px;
      border: 1px solid rgba(255, 255, 255, 0.05);
    }
    .task-title { display: flex; align-items: center; gap: 10px; font-size: 14px; }
    .category-tag {
      font-size: 11px;
      padding: 2px 8px;
      background: rgba(56, 189, 248, 0.15);
      color: #38bdf8;
      border-radius: 4px;
    }
    .btn-delete {
      background: transparent;
      color: #f87171;
      padding: 4px 8px;
      font-size: 13px;
    }
    .btn-delete:hover { background: rgba(239, 68, 68, 0.15); }
    .footer {
      margin-top: 24px;
      text-align: center;
      font-size: 12px;
      color: #64748b;
    }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      <div>
        <h1 style="font-size: 22px;">🐳 Ephemeral EKS Microservice</h1>
        <p style="color: #94a3b8; font-size: 13px; margin-top: 4px;">AWS EKS Cluster • Terraform Automated • Ephemeral Setup</p>
      </div>
      <div class="badge">
        <span class="pulse"></span> Active
      </div>
    </div>

    <div class="meta-grid">
      <div class="meta-card">
        <div class="meta-label">Serving Pod (Hostname)</div>
        <div class="meta-value" id="pod-name">${currentPod}</div>
      </div>
      <div class="meta-card">
        <div class="meta-label">Platform Architecture</div>
        <div class="meta-value">AWS EKS (t3.medium Nodes)</div>
      </div>
      <div class="meta-card">
        <div class="meta-label">Uptime</div>
        <div class="meta-value">${uptime} seconds</div>
      </div>
    </div>

    <form class="task-form" id="addTaskForm">
      <input type="text" id="taskTitle" placeholder="Add a new task (e.g. Verify LoadBalancer health)..." required />
      <button type="submit">+ Add Task</button>
    </form>

    <ul class="task-list" id="taskList">
      ${tasks.map(t => `
        <li class="task-item" id="task-${t.id}">
          <div class="task-title">
            <span>${t.completed ? '✅' : '⏳'}</span>
            <span style="${t.completed ? 'text-decoration: line-through; opacity: 0.6;' : ''}">${t.title}</span>
            <span class="category-tag">${t.category}</span>
          </div>
          <button class="btn-delete" onclick="deleteTask(${t.id})">Delete</button>
        </li>
      `).join('')}
    </ul>

    <div class="footer">
      💡 Tip: Refreshing this page distributes requests across your 2 Kubernetes replicas!
    </div>
  </div>

  <script>
    document.getElementById('addTaskForm').addEventListener('submit', async (e) => {
      e.preventDefault();
      const input = document.getElementById('taskTitle');
      const title = input.value.trim();
      if (!title) return;

      const res = await fetch('/api/tasks', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ title, category: 'Demo' })
      });

      if (res.ok) {
        window.location.reload();
      }
    });

    async function deleteTask(id) {
      const res = await fetch('/api/tasks/' + id, { method: 'DELETE' });
      if (res.ok) {
        const item = document.getElementById('task-' + id);
        if (item) item.remove();
      }
    }
  </script>
</body>
</html>`);
});

app.listen(PORT, () => {
  console.log(`[${new Date().toISOString()}] Ephemeral Microservice listening on port ${PORT}`);
  console.log(`Serving from Pod: ${os.hostname()}`);
});

