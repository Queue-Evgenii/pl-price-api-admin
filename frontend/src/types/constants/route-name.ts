
export const RouteName = {
  ADMIN: {
    ROOT: "admin-root",
    CATEGORIES: {
      ROOT: "admin-categories",
      PHOTOS: "admin-category-photos"
    },
    SITES: {
      ROOT: "admin-sites"
    },
    SETTINGS: {
      ROOT: "admin-settings"
    }
  },

  SITE: {
    ROOT: "root",
    CATEGORIES: {
      ROOT: "categories",
      DETAIL: "categories-detail",
      SLUG: "categories-slug",
    }
  },

  AUTH: {
    ROOT: "auth-root",
    SIGN_IN: "sign-in",
  },

  NOT_FOUND: "not-found",
  FORBIDDEN: "forbidden",
} as const;
