module.exports = {
  apps: [
    {
      name: 'copse',
      script: 'yarn',
      args: 'start:prod',
      interpreter: '/bin/bash',
      env_production: {
        PORT: 8008,
        NODE_ENV: 'production',
      },
    },
  ],
}
