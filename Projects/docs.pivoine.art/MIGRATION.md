# Migration Guide: Next.js 15 & Tailwind CSS 4

This guide documents the migration from Next.js 14 to 15 and Tailwind CSS 3 to 4.

## 🚀 What's New

### Next.js 15

#### Major Features
- **React 19 Support**: Now using the latest React version with improved performance
- **Turbopack Stable**: Lightning-fast bundler now stable and used by default in dev mode
- **Improved Caching**: Better caching strategies for faster builds
- **Enhanced Performance**: Overall speed improvements in both dev and production

#### Breaking Changes
- **Minimum Node.js**: Now requires Node.js 18.18.0 or higher (was 18.17.0)
- **React 19**: Some React APIs have changed, though this project is not affected
- **ESLint**: Now uses flat config format (ESLint 9)

### Tailwind CSS 4

#### Major Features
- **CSS-First Configuration**: Configure via `@theme` in CSS instead of JavaScript
- **Faster Builds**: Significantly faster compilation times
- **Smaller Bundles**: More efficient output with smaller CSS files
- **Native CSS Variables**: Better integration with modern CSS
- **Simpler Setup**: Less configuration needed

#### Breaking Changes
- **No More `@tailwind` directives**: Use `@import "tailwindcss"` instead
- **Configuration in CSS**: Use `@theme` blocks in CSS files for customization
- **Minimal JS Config**: `tailwind.config.js` only needs content paths now
- **PostCSS Simplified**: Only need Tailwind plugin in PostCSS config

## 📦 Updated Dependencies

### Before (Next.js 14 / Tailwind 3)
```json
{
  "next": "^14.2.0",
  "react": "^18.3.0",
  "react-dom": "^18.3.0",
  "tailwindcss": "^3.4.1",
  "autoprefixer": "^10.4.18"
}
```

### After (Next.js 15 / Tailwind 4)
```json
{
  "next": "^15.0.3",
  "react": "^19.0.0",
  "react-dom": "^19.0.0",
  "tailwindcss": "^4.0.0"
}
```

## 🔄 File Changes

### 1. `package.json`
- Updated Next.js to v15
- Updated React to v19
- Updated Tailwind CSS to v4
- Removed autoprefixer (now built into Tailwind 4)
- Added `--turbopack` flag to dev script
- Updated packageManager to pnpm@9.0.0

### 2. `app/globals.css`

**Before:**
```css
@tailwind base;
@tailwind components;
@tailwind utilities;
```

**After:**
```css
@import "tailwindcss";

@theme {
  /* Custom configuration here */
  --animate-pulse: pulse 4s cubic-bezier(0.4, 0, 0.6, 1) infinite;
}
```

### 3. `tailwind.config.js`

**Before:**
```js
module.exports = {
  content: ['./app/**/*.{js,ts,jsx,tsx,mdx}'],
  theme: {
    extend: {
      animation: { /* ... */ },
      backgroundImage: { /* ... */ },
    },
  },
  plugins: [],
}
```

**After:**
```js
export default {
  content: ['./app/**/*.{js,ts,jsx,tsx,mdx}'],
  // Theme configuration moved to CSS
}
```

### 4. `postcss.config.js`

**Before:**
```js
module.exports = {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
}
```

**After:**
```js
export default {
  plugins: {
    tailwindcss: {},
    // autoprefixer removed (built into Tailwind 4)
  },
}
```

### 5. `next.config.js`

**Before:**
```js
const nextConfig = {
  reactStrictMode: true,
  swcMinify: true,
  // ...
}

module.exports = nextConfig
```

**After:**
```js
const nextConfig = {
  reactStrictMode: true,
  // swcMinify removed (default in Next.js 15)
  // Turbopack is now stable and default
  // ...
}

export default nextConfig
```

### 6. ESLint Configuration

**Before:** `.eslintrc.json`
```json
{
  "extends": ["next/core-web-vitals", "next/typescript"]
}
```

**After:** `eslint.config.mjs`
```js
import { FlatCompat } from "@eslint/eslintrc";

const compat = new FlatCompat({
  baseDirectory: __dirname,
});

export default [
  ...compat.extends("next/core-web-vitals", "next/typescript"),
];
```

## ✅ Migration Checklist

If you're migrating an existing project:

- [ ] Update Node.js to 18.18.0 or higher
- [ ] Update package.json dependencies
- [ ] Run `pnpm install` to install new versions
- [ ] Update `app/globals.css` to use `@import "tailwindcss"`
- [ ] Move Tailwind theme config from JS to CSS using `@theme`
- [ ] Simplify `tailwind.config.js` (remove theme extensions)
- [ ] Update `postcss.config.js` to remove autoprefixer
- [ ] Update `next.config.js` to use ES modules (export default)
- [ ] Create `eslint.config.mjs` with flat config format
- [ ] Remove old `.eslintrc.json` file
- [ ] Update `.nvmrc` to 18.18.0
- [ ] Test the application: `pnpm dev`
- [ ] Build for production: `pnpm build`
- [ ] Update README and documentation

## 🎯 Benefits After Migration

### Performance Improvements
- **~10x faster dev server** startup with Turbopack
- **Faster CSS compilation** with Tailwind 4
- **Smaller bundle sizes** in production
- **Better hot reload** performance

### Developer Experience
- **Simpler configuration** - less boilerplate
- **Better error messages** - clearer debugging
- **Faster feedback loop** - instant updates
- **Modern tooling** - latest ecosystem features

### Future-Proof
- Using the latest stable versions
- Better long-term support
- Access to newest features
- Compatible with latest ecosystem tools

## 🐛 Troubleshooting

### Issue: Dev server won't start
**Solution**: Clear cache and reinstall
```bash
rm -rf .next node_modules
pnpm install
pnpm dev
```

### Issue: Tailwind classes not working
**Solution**: Check your `globals.css` uses `@import "tailwindcss"`
```css
@import "tailwindcss";
```

### Issue: TypeScript errors
**Solution**: Ensure tsconfig.json is updated and regenerate types
```bash
rm -rf .next
pnpm dev
```

### Issue: ESLint errors
**Solution**: Ensure you're using the new flat config format in `eslint.config.mjs`

### Issue: Build fails
**Solution**: Check Node.js version
```bash
node --version  # Should be 18.18.0+
```

## 📚 Additional Resources

- [Next.js 15 Release Notes](https://nextjs.org/blog/next-15)
- [Tailwind CSS 4.0 Documentation](https://tailwindcss.com/docs/v4-beta)
- [React 19 Release Notes](https://react.dev/blog/2024/12/05/react-19)
- [Turbopack Documentation](https://turbo.build/pack/docs)

## 🎉 Conclusion

The migration to Next.js 15 and Tailwind CSS 4 brings significant performance improvements and a better developer experience. The changes are minimal but impactful, setting up your project for the future of web development.

If you encounter any issues not covered here, please refer to the official documentation or reach out for support.

---

**Migrated with ❤️ by Valknar** | [pivoine.art](http://pivoine.art)
