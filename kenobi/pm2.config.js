module.exports = {
  apps: [
    {
      name: 'kenobi',
      script: 'yarn',
      args: 'start:prod',
      interpreter: '/bin/bash',
      env_production: {
        PORT: 8009,
        NODE_ENV: 'production',
      },
    },
  ],
}
