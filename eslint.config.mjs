import appiumConfig from '@appium/eslint-config-appium-ts';

export default [
  ...appiumConfig,
  {
    ignores: [
      'UIKitCatalog/**',
      'node_modules/**',
    ],
  },
];

