<script setup lang="ts">
import { computed, onMounted, ref, watch } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { RouteName } from '@/types/constants/route-name';
import { useSitesStore } from '@/stores/sites';
import { useCeilingProjectsStore, type Ceiling, type ColorPreset, type Project, type Variant } from '@/stores/ceiling-projects';
import { Site } from '@/types/models/utils/browser/site';
import logoUrl from '@/assets/logo.png';
import { AddRound, AllInclusiveRound, CheckRound, CloseRound, DomainAddRound, EditRound, HouseRound, RemoveRound, StarBorderRound, StarRound } from '@vicons/material';

type ViewMode = 'project-create' | 'project-summary' | 'ceiling-edit' | 'ceiling-view';
type Notification = { id: string; type: 'success' | 'error'; text: string };
type PendingNavigation = { type: 'project' | 'ceiling' | 'ceiling-view' | 'new-project' | 'new-ceiling' | 'catalog' | 'site'; projectId?: string; ceilingId?: string; lang?: string };
type PlannerLocale = 'en' | 'pl';

const minCorners = 3;
const maxCorners = 24;

const router = useRouter();
const route = useRoute();
const sitesStore = useSitesStore();
const ceilingProjectsStore = useCeilingProjectsStore();

const langOpts = ref(sitesStore.opts);
const curOpt = ref((route.params.lang as string) || Site.get() || 'pl');
const plannerLocale = computed<PlannerLocale>(() => curOpt.value === 'pl' ? 'pl' : 'en');
const localeCode = computed(() => plannerLocale.value === 'pl' ? 'pl-PL' : 'en-US');
const projects = computed({
  get: () => ceilingProjectsStore.projects,
  set: (value: Project[]) => ceilingProjectsStore.setProjectsDraft(value),
});
const activeProjectId = ref<string | null>(null);
const activeCeilingId = ref<string | null>(null);
const viewMode = ref<ViewMode>('project-create');
const projectSummaryView = ref<'numbers' | 'visuals'>('numbers');
const projectNameDraft = ref('');
const editingProjectId = ref<string | null>(null);
const projectRenameDraft = ref('');
const notifications = ref<Notification[]>([]);
const isProjectsDrawerOpen = ref(false);
const isCeilingsDrawerOpen = ref(false);
const activeColorPickerKey = ref<string | null>(null);
const isLocalNoticeVisible = ref(true);
const isNewCeilingPendingSave = ref(false);
const pendingNavigation = ref<PendingNavigation | null>(null);
const ceilingToDelete = ref<Ceiling | null>(null);
const projectToDelete = ref<Project | null>(null);
const lastSavedSnapshot = ref('');
const changedSideIndex = ref<number | null>(null);
const sideChangeDirection = ref<'up' | 'down' | null>(null);
const isCornersChanged = ref(false);
const cornersChangeDirection = ref<'up' | 'down' | null>(null);
const changedSummaryKey = ref<'area' | 'perimeter' | 'price' | null>(null);
const summaryChangeDirection = ref<'up' | 'down' | null>(null);
let sideAnimationTimer: number | null = null;
let cornersAnimationTimer: number | null = null;
let summaryAnimationTimer: number | null = null;
let previousSummary = { area: 0, perimeter: 0, price: 0 };

const ceilingColors: ColorPreset[] = [
  { label: 'Warm white', value: '#f7f4ef' },
  { label: 'Pure white', value: '#ffffff' },
  { label: 'Matte white', value: '#f1f1ee' },
  { label: 'Pearl', value: '#e9e4dc' },
  { label: 'Ivory', value: '#f2ead7' },
  { label: 'Champagne', value: '#e7d2a9' },
  { label: 'Sand', value: '#d7c3a2' },
  { label: 'Light grey', value: '#d8dde2' },
  { label: 'Silver grey', value: '#b9c0c8' },
  { label: 'Graphite', value: '#33363b' },
  { label: 'Black mirror', value: '#151515' },
  { label: 'Sky gloss', value: '#b9d8ef' },
  { label: 'Ice blue', value: '#d8edf7' },
  { label: 'Navy', value: '#1d3557' },
  { label: 'Sage', value: '#b7c8b0' },
  { label: 'Olive', value: '#6f7755' },
  { label: 'Blush', value: '#ead0d2' },
  { label: 'Terracotta', value: '#b8654b' },
  { label: 'Burgundy', value: '#6e1f2f' },
  { label: 'Chocolate', value: '#5a3d2b' },
];

const messages = {
  en: {
    actions: {
      addVariant: 'Add variant',
      cancel: 'Cancel',
      catalog: 'Catalog',
      color: 'Color',
      delete: 'Delete',
      discard: "Don't save",
      edit: 'Edit',
      full: 'Full',
      projects: 'Projects',
      rename: 'Rename',
      save: 'Save',
    },
    aria: {
      close: 'Close',
      deleteCeiling: 'Delete ceiling',
      deleteProject: 'Delete project',
      decreaseLength: 'Decrease length',
      increaseLength: 'Increase length',
      preview: 'Ceiling plan preview',
      renameProject: 'Rename project',
      saveProjectName: 'Save project name',
    },
    colors: {
      'Warm white': 'Warm white',
      'Pure white': 'Pure white',
      'Matte white': 'Matte white',
      Pearl: 'Pearl',
      Ivory: 'Ivory',
      Champagne: 'Champagne',
      Sand: 'Sand',
      'Light grey': 'Light grey',
      'Silver grey': 'Silver grey',
      Graphite: 'Graphite',
      'Black mirror': 'Black mirror',
      'Sky gloss': 'Sky gloss',
      'Ice blue': 'Ice blue',
      Navy: 'Navy',
      Sage: 'Sage',
      Olive: 'Olive',
      Blush: 'Blush',
      Terracotta: 'Terracotta',
      Burgundy: 'Burgundy',
      Chocolate: 'Chocolate',
    },
    empty: {
      colors: 'Add the first ceiling to see totals.',
      projects: 'No projects yet.',
      ceilings: 'No ceilings yet.',
      visuals: 'Add the first ceiling to see selected visuals.',
    },
    labels: {
      area: 'Area',
      byColor: 'By color',
      ceiling: 'Ceiling',
      ceilings: 'Ceilings',
      color: 'Color',
      colorOption: 'Color option',
      colors: 'Colors',
      colorVariants: 'Color variants',
      corners: 'Corners',
      createProject: 'Create project',
      estimator: 'Estimator',
      house: 'House',
      name: 'Name',
      newCeiling: 'New ceiling',
      newProject: 'New project',
      numbers: 'Numbers',
      perimeter: 'Perimeter',
      price: 'Price',
      project: 'Project',
      projectName: 'Project name',
      rooms: 'Rooms',
      selectedCeilings: 'Selected ceilings',
      selectedForTotal: 'Selected for total',
      totalArea: 'Total area',
      totalPrice: 'Total price',
      view: 'View',
      visuals: 'Visuals',
    },
    modal: {
      ceilingDeleteCopy: 'This ceiling will be removed from the project.',
      ceilingDeleteTitle: 'Delete ceiling?',
      projectDeleteCopy: 'This local project and its ceilings will be removed.',
      projectDeleteTitle: 'Delete project?',
      unsavedCopy: 'You have changes in this ceiling.',
      unsavedTitle: 'Save changes?',
    },
    notices: {
      local: 'Saved only on this device.',
    },
    placeholders: {
      projectName: 'House project',
    },
    text: {
      projectIntro: 'Start with a house, apartment, or client object.',
    },
    toasts: {
      ceilingAdded: 'Ceiling added',
      ceilingDeleted: 'Ceiling deleted',
      ceilingSaved: 'Ceiling saved',
      keepVariant: 'Keep at least one variant',
      projectCreated: 'Project created',
      projectDeleted: 'Project deleted',
      projectRenamed: 'Project renamed',
      variantAdded: 'Variant added',
    },
  },
  pl: {
    actions: {
      addVariant: 'Dodaj wariant',
      cancel: 'Anuluj',
      catalog: 'Katalog',
      color: 'Kolor',
      delete: 'Usuń',
      discard: 'Nie zapisuj',
      edit: 'Edytuj',
      full: 'Pełny',
      projects: 'Projekty',
      rename: 'Zmień nazwę',
      save: 'Zapisz',
    },
    aria: {
      close: 'Zamknij',
      deleteCeiling: 'Usuń sufit',
      deleteProject: 'Usuń projekt',
      decreaseLength: 'Zmniejsz długość',
      increaseLength: 'Zwiększ długość',
      preview: 'Podgląd planu sufitu',
      renameProject: 'Zmień nazwę projektu',
      saveProjectName: 'Zapisz nazwę projektu',
    },
    colors: {
      'Warm white': 'Ciepła biel',
      'Pure white': 'Czysta biel',
      'Matte white': 'Matowa biel',
      Pearl: 'Perłowy',
      Ivory: 'Kość słoniowa',
      Champagne: 'Szampański',
      Sand: 'Piaskowy',
      'Light grey': 'Jasnoszary',
      'Silver grey': 'Srebrnoszary',
      Graphite: 'Grafitowy',
      'Black mirror': 'Czarne lustro',
      'Sky gloss': 'Błękitny połysk',
      'Ice blue': 'Lodowy błękit',
      Navy: 'Granatowy',
      Sage: 'Szałwiowy',
      Olive: 'Oliwkowy',
      Blush: 'Pudrowy róż',
      Terracotta: 'Terakota',
      Burgundy: 'Bordowy',
      Chocolate: 'Czekoladowy',
    },
    empty: {
      colors: 'Dodaj pierwszy sufit, aby zobaczyć podsumowanie.',
      projects: 'Nie ma jeszcze projektów.',
      ceilings: 'Nie ma jeszcze sufitów.',
      visuals: 'Dodaj pierwszy sufit, aby zobaczyć wizualizacje.',
    },
    labels: {
      area: 'Powierzchnia',
      byColor: 'Według koloru',
      ceiling: 'Sufit',
      ceilings: 'Sufity',
      color: 'Kolor',
      colorOption: 'Opcja koloru',
      colors: 'Kolory',
      colorVariants: 'Warianty kolorów',
      corners: 'Narożniki',
      createProject: 'Utwórz projekt',
      estimator: 'Kalkulator',
      house: 'Dom',
      name: 'Nazwa',
      newCeiling: 'Nowy sufit',
      newProject: 'Nowy projekt',
      numbers: 'Liczby',
      perimeter: 'Obwód',
      price: 'Cena',
      project: 'Projekt',
      projectName: 'Nazwa projektu',
      rooms: 'Pomieszczenia',
      selectedCeilings: 'Wybrane sufity',
      selectedForTotal: 'Wybrany do podsumowania',
      totalArea: 'Łączna powierzchnia',
      totalPrice: 'Łączna cena',
      view: 'Widok',
      visuals: 'Wizualizacje',
    },
    modal: {
      ceilingDeleteCopy: 'Ten sufit zostanie usunięty z projektu.',
      ceilingDeleteTitle: 'Usunąć sufit?',
      projectDeleteCopy: 'Ten lokalny projekt i jego sufity zostaną usunięte.',
      projectDeleteTitle: 'Usunąć projekt?',
      unsavedCopy: 'Masz niezapisane zmiany w tym suficie.',
      unsavedTitle: 'Zapisać zmiany?',
    },
    notices: {
      local: 'Zapisane tylko na tym urządzeniu.',
    },
    placeholders: {
      projectName: 'Projekt domu',
    },
    text: {
      projectIntro: 'Zacznij od domu, mieszkania albo obiektu klienta.',
    },
    toasts: {
      ceilingAdded: 'Sufit dodany',
      ceilingDeleted: 'Sufit usunięty',
      ceilingSaved: 'Sufit zapisany',
      keepVariant: 'Zostaw co najmniej jeden wariant',
      projectCreated: 'Projekt utworzony',
      projectDeleted: 'Projekt usunięty',
      projectRenamed: 'Nazwa projektu zapisana',
      variantAdded: 'Wariant dodany',
    },
  },
} as const;

const t = computed(() => messages[plannerLocale.value]);
const trColor = (name = '') => t.value.colors[name as keyof typeof t.value.colors] || name;

const activeProject = computed(() => projects.value.find(project => project.id === activeProjectId.value) || null);
const activeCeiling = computed(() => activeProject.value?.ceilings.find(ceiling => ceiling.id === activeCeilingId.value) || null);
const activeVariant = computed(() => {
  const ceiling = activeCeiling.value;
  if (!ceiling) return null;
  return ceiling.variants.find(variant => variant.id === ceiling.activeVariantId) || ceiling.variants[0] || null;
});

const sortedProjects = computed(() => [...projects.value].sort((a, b) => dateValue(b.createdAt) - dateValue(a.createdAt)));
const sortedCeilings = computed(() => [...(activeProject.value?.ceilings || [])].sort((a, b) => dateValue(b.createdAt) - dateValue(a.createdAt)));
const sortedVariants = computed(() => [...(activeCeiling.value?.variants || [])].sort((a, b) => Number(b.isFavorite) - Number(a.isFavorite) || dateValue(a.createdAt) - dateValue(b.createdAt)));

const labels = computed(() => Array.from({ length: activeCeiling.value?.corners || 0 }, (_, index) => getCornerLabel(index)));
const perimeter = computed(() => calculatePerimeter(activeCeiling.value));
const area = computed(() => calculateArea(activeCeiling.value));
const price = computed(() => calculatePrice(activeCeiling.value));
const projectTotals = computed(() => calculateProjectTotals(activeProject.value));
const colorTotals = computed(() => calculateColorTotals(activeProject.value));
const polygonPoints = computed(() => getPoints(activeCeiling.value).map(point => `${point.x},${point.y}`).join(' '));
const isDirty = computed(() => Boolean(activeCeiling.value) && ceilingSnapshot(activeCeiling.value) !== lastSavedSnapshot.value);
const shouldShowSave = computed(() => Boolean(activeCeiling.value) && (isDirty.value || isNewCeilingPendingSave.value));

const isUnsavedModalOpen = computed({
  get: () => pendingNavigation.value !== null,
  set: value => {
    if (!value) pendingNavigation.value = null;
  },
});

const isCeilingDeleteOpen = computed({
  get: () => ceilingToDelete.value !== null,
  set: value => {
    if (!value) ceilingToDelete.value = null;
  },
});

const isProjectDeleteOpen = computed({
  get: () => projectToDelete.value !== null,
  set: value => {
    if (!value) projectToDelete.value = null;
  },
});
const isAnyModalOpen = computed(() => isUnsavedModalOpen.value || isCeilingDeleteOpen.value || isProjectDeleteOpen.value);

const createId = () => `${Date.now()}-${Math.random().toString(16).slice(2)}`;
const dateValue = (date: string) => new Date(date).getTime() || 0;
const numberOrZero = (value: number) => Number.isFinite(Number(value)) ? Number(value) : 0;
const formatNumber = (value: number) => value.toLocaleString(localeCode.value, { maximumFractionDigits: 2, minimumFractionDigits: 0 });
const formatCurrency = (value: number) => `${formatNumber(Math.round(value))} PLN`;
const formatArea = (value: number) => `${formatNumber(value)} m²`;
const formatDate = (date: string) => new Date(date).toLocaleDateString(localeCode.value, { day: '2-digit', month: '2-digit', year: 'numeric' });
const getCornerLabel = (index: number) => {
  const letter = String.fromCharCode(65 + (index % 26));
  const suffix = Math.floor(index / 26);
  return suffix > 0 ? `${letter}${suffix}` : letter;
};

const getPoints = (ceiling: Ceiling | null) => {
  if (!ceiling) return [];
  const centerX = 150;
  const centerY = 130;
  const radiusX = ceiling.corners > 6 ? 112 : 104;
  const radiusY = ceiling.corners > 6 ? 90 : 84;
  return Array.from({ length: ceiling.corners }, (_, index) => {
    const angle = -Math.PI / 2 + (2 * Math.PI * index) / ceiling.corners;
    return { x: centerX + Math.cos(angle) * radiusX, y: centerY + Math.sin(angle) * radiusY };
  });
};

const getPolygonPoints = (ceiling: Ceiling | null) => getPoints(ceiling).map(point => `${point.x},${point.y}`).join(' ');

const calculatePerimeter = (ceiling: Ceiling | null) => ceiling ? ceiling.sides.reduce((sum, side) => sum + numberOrZero(side), 0) : 0;
const calculateArea = (ceiling: Ceiling | null) => {
  if (!ceiling) return 0;
  const ceilingPerimeter = calculatePerimeter(ceiling);
  const averageSide = ceilingPerimeter / ceiling.corners;
  const apothem = averageSide / (2 * Math.tan(Math.PI / ceiling.corners));
  return ceilingPerimeter * apothem / 2;
};
const calculatePrice = (ceiling: Ceiling | null) => Math.round(calculateArea(ceiling) * 95 + calculatePerimeter(ceiling) * 18);
const selectedVariant = (ceiling: Ceiling) => ceiling.variants.find(variant => variant.isFavorite) || ceiling.variants.find(variant => variant.id === ceiling.activeVariantId) || ceiling.variants[0];

const calculateProjectTotals = (project: Project | null) => {
  const ceilings = project?.ceilings || [];
  return ceilings.reduce((totals, ceiling) => ({
    area: totals.area + calculateArea(ceiling),
    perimeter: totals.perimeter + calculatePerimeter(ceiling),
    price: totals.price + calculatePrice(ceiling),
    count: totals.count + 1,
  }), { area: 0, perimeter: 0, price: 0, count: 0 });
};

const calculateColorTotals = (project: Project | null) => {
  const totals = new Map<string, { color: string; colorName: string; area: number; price: number; count: number }>();
  for (const ceiling of project?.ceilings || []) {
    const variant = selectedVariant(ceiling);
    if (!variant) continue;
    const key = variant.colorName;
    const current = totals.get(key) || { color: variant.color, colorName: variant.colorName, area: 0, price: 0, count: 0 };
    current.area += calculateArea(ceiling);
    current.price += calculatePrice(ceiling);
    current.count += 1;
    totals.set(key, current);
  }
  return [...totals.values()].sort((a, b) => b.area - a.area);
};

const ceilingSnapshot = (ceiling: Ceiling) => JSON.stringify({
  name: ceiling.name,
  corners: ceiling.corners,
  sides: ceiling.sides,
  variants: ceiling.variants,
  activeVariantId: ceiling.activeVariantId,
});

const restoreCeilingFromSnapshot = (ceiling: Ceiling, snapshot: string): Ceiling => {
  const saved = JSON.parse(snapshot) as Pick<Ceiling, 'name' | 'corners' | 'sides' | 'variants' | 'activeVariantId'>;
  return { ...ceiling, ...saved };
};

const createVariant = (color = ceilingColors[0], favorite = true): Variant => ({
  id: createId(),
  color: color.value,
  colorName: color.label,
  isFavorite: favorite,
  createdAt: new Date().toISOString(),
});

const createCeiling = (name = `Ceiling ${(activeProject.value?.ceilings.length || 0) + 1}`): Ceiling => {
  const variant = createVariant(ceilingColors[0], true);
  return {
    id: createId(),
    name,
    corners: 4,
    sides: [3.2, 4.1, 3.2, 4.1],
    variants: [variant],
    activeVariantId: variant.id,
    createdAt: new Date().toISOString(),
  };
};

const notify = (type: Notification['type'], text: string) => {
  const id = createId();
  notifications.value = [{ id, type, text }, ...notifications.value].slice(0, 3);
  window.setTimeout(() => {
    notifications.value = notifications.value.filter(notification => notification.id !== id);
  }, 2800);
};

const persistProjects = () => ceilingProjectsStore.persist();

const mutateActiveProject = (updater: (project: Project) => Project, shouldPersist = false) => {
  if (!activeProjectId.value) return;
  projects.value = projects.value.map(project => project.id === activeProjectId.value ? updater(project) : project);
  if (shouldPersist) persistProjects();
};

const mutateActiveCeiling = (updater: (ceiling: Ceiling) => Ceiling) => {
  if (!activeCeilingId.value) return;
  mutateActiveProject(project => ({
    ...project,
    ceilings: project.ceilings.map(ceiling => ceiling.id === activeCeilingId.value ? updater(ceiling) : ceiling),
    updatedAt: new Date().toISOString(),
  }));
};

const loadProjects = () => {
  if (projects.value.length === 0) {
    viewMode.value = 'project-create';
    return;
  }
  activeProjectId.value = projects.value[0].id;
  viewMode.value = 'project-summary';
};

const createProject = () => {
  const name = projectNameDraft.value.trim() || t.value.placeholders.projectName;
  const project: Project = { id: createId(), name, ceilings: [], createdAt: new Date().toISOString() };
  projects.value = [project, ...projects.value];
  activeProjectId.value = project.id;
  activeCeilingId.value = null;
  viewMode.value = 'project-summary';
  persistProjects();
  notify('success', t.value.toasts.projectCreated);
};

const startProjectRename = (project: Project) => {
  editingProjectId.value = project.id;
  projectRenameDraft.value = project.name;
};

const cancelProjectRename = () => {
  editingProjectId.value = null;
  projectRenameDraft.value = '';
};

const saveProjectRename = (projectId = editingProjectId.value) => {
  if (!projectId) return;
  const fallbackName = projects.value.find(project => project.id === projectId)?.name || t.value.placeholders.projectName;
  const name = projectRenameDraft.value.trim() || fallbackName;
  projects.value = projects.value.map(project => project.id === projectId
    ? { ...project, name, updatedAt: new Date().toISOString() }
    : project);
  editingProjectId.value = null;
  projectRenameDraft.value = '';
  persistProjects();
  notify('success', t.value.toasts.projectRenamed);
};

const requestNavigation = (navigation: PendingNavigation) => {
  if (viewMode.value === 'ceiling-edit' && (isDirty.value || isNewCeilingPendingSave.value)) {
    pendingNavigation.value = navigation;
    return;
  }
  runNavigation(navigation);
};

const runNavigation = (navigation: PendingNavigation) => {
  if (navigation.type === 'new-project') {
    activeProjectId.value = null;
    activeCeilingId.value = null;
    projectNameDraft.value = '';
    cancelProjectRename();
    viewMode.value = 'project-create';
    isProjectsDrawerOpen.value = false;
    isCeilingsDrawerOpen.value = false;
    return;
  }
  if (navigation.type === 'project' && navigation.projectId) {
    activeProjectId.value = navigation.projectId;
    activeCeilingId.value = null;
    cancelProjectRename();
    viewMode.value = 'project-summary';
    isProjectsDrawerOpen.value = false;
    isCeilingsDrawerOpen.value = false;
    return;
  }
  if (navigation.type === 'new-ceiling') {
    isProjectsDrawerOpen.value = false;
    isCeilingsDrawerOpen.value = false;
    addCeiling();
    return;
  }
  if (navigation.type === 'ceiling' && navigation.ceilingId) {
    openCeiling(navigation.ceilingId);
  }
  if (navigation.type === 'ceiling-view') {
    viewMode.value = activeCeiling.value ? 'ceiling-view' : 'project-summary';
  }
  if (navigation.type === 'catalog') {
    router.push({ name: RouteName.SITE.CATEGORIES.ROOT, params: { lang: curOpt.value } });
  }
  if (navigation.type === 'site' && navigation.lang) {
    curOpt.value = navigation.lang;
    router.push({ name: RouteName.SITE.PLANNER, params: { lang: navigation.lang } });
  }
};

const saveCurrentCeiling = () => {
  if (!activeCeiling.value) return;
  lastSavedSnapshot.value = ceilingSnapshot(activeCeiling.value);
  isNewCeilingPendingSave.value = false;
  persistProjects();
  notify('success', t.value.toasts.ceilingSaved);
};

const saveAndContinue = () => {
  const navigation = pendingNavigation.value;
  saveCurrentCeiling();
  pendingNavigation.value = null;
  if (navigation) runNavigation(navigation);
};

const discardAndContinue = () => {
  const navigation = pendingNavigation.value;
  if (activeProject.value && activeCeiling.value) {
    const discardedId = activeCeiling.value.id;
    if (isNewCeilingPendingSave.value) {
      mutateActiveProject(project => ({ ...project, ceilings: project.ceilings.filter(ceiling => ceiling.id !== discardedId), updatedAt: new Date().toISOString() }), true);
      activeCeilingId.value = null;
      isNewCeilingPendingSave.value = false;
    } else if (lastSavedSnapshot.value) {
      mutateActiveCeiling(ceiling => restoreCeilingFromSnapshot(ceiling, lastSavedSnapshot.value));
    }
  }
  pendingNavigation.value = null;
  if (navigation) runNavigation(navigation);
};

const addCeiling = () => {
  if (!activeProject.value) return;
  const ceiling = createCeiling(`${t.value.labels.ceiling} ${activeProject.value.ceilings.length + 1}`);
  mutateActiveProject(project => ({ ...project, ceilings: [ceiling, ...project.ceilings], updatedAt: new Date().toISOString() }));
  activeCeilingId.value = ceiling.id;
  viewMode.value = 'ceiling-edit';
  lastSavedSnapshot.value = ceilingSnapshot(ceiling);
  isNewCeilingPendingSave.value = true;
  notify('success', t.value.toasts.ceilingAdded);
};

const openCeiling = (ceilingId: string) => {
  activeCeilingId.value = ceilingId;
  viewMode.value = 'ceiling-view';
  isProjectsDrawerOpen.value = false;
  isCeilingsDrawerOpen.value = false;
  isNewCeilingPendingSave.value = false;
  if (activeCeiling.value) lastSavedSnapshot.value = ceilingSnapshot(activeCeiling.value);
};

const editCeiling = () => {
  if (!activeCeiling.value) return;
  viewMode.value = 'ceiling-edit';
  isNewCeilingPendingSave.value = false;
  lastSavedSnapshot.value = ceilingSnapshot(activeCeiling.value);
};

const updateCeilingName = (name: string) => mutateActiveCeiling(ceiling => ({ ...ceiling, name, updatedAt: new Date().toISOString() }));
const changeCorners = (value: number) => {
  if (!activeCeiling.value) return;
  const previous = activeCeiling.value.corners;
  const normalized = Math.min(maxCorners, Math.max(minCorners, Math.round(numberOrZero(value))));
  const next = [...activeCeiling.value.sides];
  while (next.length < normalized) next.push(3);
  mutateActiveCeiling(ceiling => ({ ...ceiling, corners: normalized, sides: next.slice(0, normalized), updatedAt: new Date().toISOString() }));
  markCornersChanged(normalized > previous ? 'up' : 'down');
};

const updateSide = (index: number, delta: number) => {
  if (!activeCeiling.value) return;
  const nextValue = Math.max(0.2, Math.round((numberOrZero(activeCeiling.value.sides[index]) + delta) * 10) / 10);
  mutateActiveCeiling(ceiling => {
    const sides = [...ceiling.sides];
    sides[index] = nextValue;
    return { ...ceiling, sides, updatedAt: new Date().toISOString() };
  });
  markSideChanged(index, delta > 0 ? 'up' : 'down');
};

const setSide = (index: number, value: number) => {
  mutateActiveCeiling(ceiling => {
    const sides = [...ceiling.sides];
    sides[index] = Math.max(0.2, numberOrZero(value));
    return { ...ceiling, sides, updatedAt: new Date().toISOString() };
  });
  markSideChanged(index, 'up');
};

const addVariant = () => {
  if (!activeCeiling.value) return;
  const color = ceilingColors[(activeCeiling.value.variants.length + 2) % ceilingColors.length];
  const variant = createVariant(color, false);
  mutateActiveCeiling(ceiling => ({ ...ceiling, variants: [...ceiling.variants, variant], activeVariantId: variant.id, updatedAt: new Date().toISOString() }));
  notify('success', t.value.toasts.variantAdded);
};

const selectVariant = (variant: Variant) => mutateActiveCeiling(ceiling => ({ ...ceiling, activeVariantId: variant.id, updatedAt: new Date().toISOString() }));
const changeVariantColor = (color: ColorPreset) => {
  if (!activeCeiling.value) return;
  const activeId = activeCeiling.value.activeVariantId;
  mutateActiveCeiling(ceiling => ({
    ...ceiling,
    variants: ceiling.variants.map(variant => variant.id === activeId ? { ...variant, color: color.value, colorName: color.label } : variant),
    updatedAt: new Date().toISOString(),
  }));
  activeColorPickerKey.value = null;
};

const toggleFavorite = (variant: Variant) => mutateActiveCeiling(ceiling => ({
  ...ceiling,
  variants: ceiling.variants.map(item => ({ ...item, isFavorite: item.id === variant.id ? !item.isFavorite : false })),
  updatedAt: new Date().toISOString(),
}));

const deleteVariant = (variant: Variant) => {
  if (!activeCeiling.value || activeCeiling.value.variants.length <= 1) {
    notify('error', t.value.toasts.keepVariant);
    return;
  }
  mutateActiveCeiling(ceiling => {
    const variants = ceiling.variants.filter(item => item.id !== variant.id);
    return { ...ceiling, variants, activeVariantId: variants[0].id, updatedAt: new Date().toISOString() };
  });
};

const confirmDeleteCeiling = () => {
  if (!activeProject.value || !ceilingToDelete.value) return;
  const deletedId = ceilingToDelete.value.id;
  mutateActiveProject(project => ({ ...project, ceilings: project.ceilings.filter(ceiling => ceiling.id !== deletedId), updatedAt: new Date().toISOString() }), true);
  if (activeCeilingId.value === deletedId) {
    activeCeilingId.value = null;
    viewMode.value = 'project-summary';
  }
  ceilingToDelete.value = null;
  notify('success', t.value.toasts.ceilingDeleted);
};

const confirmDeleteProject = () => {
  if (!projectToDelete.value) return;
  const deletedId = projectToDelete.value.id;
  projects.value = projects.value.filter(project => project.id !== deletedId);
  activeProjectId.value = projects.value[0]?.id || null;
  activeCeilingId.value = null;
  viewMode.value = activeProjectId.value ? 'project-summary' : 'project-create';
  projectToDelete.value = null;
  isProjectsDrawerOpen.value = false;
  persistProjects();
  notify('success', t.value.toasts.projectDeleted);
};

const markCornersChanged = (direction: 'up' | 'down') => {
  isCornersChanged.value = true;
  cornersChangeDirection.value = direction;
  if (cornersAnimationTimer) window.clearTimeout(cornersAnimationTimer);
  cornersAnimationTimer = window.setTimeout(() => {
    isCornersChanged.value = false;
    cornersChangeDirection.value = null;
  }, 520);
};

const markSideChanged = (index: number, direction: 'up' | 'down' = 'up') => {
  changedSideIndex.value = index;
  sideChangeDirection.value = direction;
  if (sideAnimationTimer) window.clearTimeout(sideAnimationTimer);
  sideAnimationTimer = window.setTimeout(() => {
    changedSideIndex.value = null;
    sideChangeDirection.value = null;
  }, 520);
};

const markSummaryChanged = () => {
  const next = projectTotals.value;
  const direction = next.price > previousSummary.price ? 'up' : 'down';
  previousSummary = { area: next.area, perimeter: next.perimeter, price: next.price };
  summaryChangeDirection.value = direction;
  changedSummaryKey.value = 'area';
  if (summaryAnimationTimer) window.clearTimeout(summaryAnimationTimer);
  window.setTimeout(() => { changedSummaryKey.value = 'perimeter'; }, 80);
  window.setTimeout(() => { changedSummaryKey.value = 'price'; }, 160);
  summaryAnimationTimer = window.setTimeout(() => {
    changedSummaryKey.value = null;
    summaryChangeDirection.value = null;
  }, 680);
};

const openCatalog = () => requestNavigation({ type: 'catalog' });
const changeSite = async (newOptValue: string) => {
  requestNavigation({ type: 'site', lang: newOptValue });
};

watch(projectTotals, markSummaryChanged);
onMounted(() => {
  loadProjects();
  previousSummary = { ...projectTotals.value };
});
</script>

<template>
  <div class="builder-page" :class="{ 'builder-page--with-local-notice': isLocalNoticeVisible }">
    <div v-if="!isAnyModalOpen" class="notifications" aria-live="polite">
      <div v-for="notification in notifications" :key="notification.id" class="notification" :class="`notification--${notification.type}`">
        {{ notification.text }}
      </div>
    </div>

    <header class="builder-top">
      <img :src="logoUrl" alt="Poland Group" class="builder-logo">
      <div class="top-actions">
        <n-button v-if="projects.length > 0" secondary @click="isProjectsDrawerOpen = true">{{ t.actions.projects }}</n-button>
        <n-button secondary data-tour="catalog-link" @click="openCatalog">{{ t.actions.catalog }}</n-button>
        <n-select class="builder-lang" data-tour="planner-lang" :value="curOpt" :options="langOpts" @update:value="changeSite" />
      </div>
    </header>

    <main class="builder-shell" :class="{ 'builder-shell--with-fab': viewMode === 'project-create' || viewMode === 'project-summary' }">
      <div v-if="isLocalNoticeVisible && !isAnyModalOpen" class="local-notice">
        <span>{{ t.notices.local }}</span>
        <button type="button" :aria-label="t.aria.close" @click="isLocalNoticeVisible = false"><n-icon :component="CloseRound" /></button>
      </div>

      <nav v-if="viewMode !== 'project-create'" class="breadcrumbs">
        <button v-if="activeCeiling" type="button" data-tour="project-summary-link" @click="requestNavigation({ type: 'project', projectId: activeProjectId || undefined })">{{ activeProject?.name || t.labels.project }}</button>
        <span v-else class="breadcrumbs__current">{{ activeProject?.name || t.labels.project }}</span>
        <span v-if="activeCeiling">/</span>
        <button v-if="activeCeiling" type="button" @click="isCeilingsDrawerOpen = true">{{ t.labels.ceilings }}</button>
        <span v-if="activeCeiling">/</span>
        <button v-if="activeCeiling" type="button" @click="requestNavigation({ type: 'ceiling-view' })">{{ activeCeiling.name }}</button>
      </nav>

      <section v-if="viewMode === 'project-create'" class="create-screen">
        <div class="create-card">
          <div class="create-card__header">
            <span class="create-badge">{{ t.labels.estimator }}</span>
            <h1 data-tour="planner-title">{{ t.labels.createProject }}</h1>
            <p>{{ t.text.projectIntro }}</p>
          </div>
          <label class="create-field" data-tour="project-name">
            <span>{{ t.labels.projectName }}</span>
            <n-input v-model:value="projectNameDraft" :placeholder="t.placeholders.projectName" />
          </label>
          <div class="create-preview">
            <button type="button" data-tour="create-project" @click="createProject">
              <strong><n-icon :component="AddRound" /></strong>
              <span>{{ t.labels.newProject }}</span>
            </button>
            <div>
              <strong><n-icon :component="AllInclusiveRound" /></strong>
              <span>{{ t.labels.rooms }}</span>
            </div>
            <div>
              <strong><n-icon :component="StarRound" /></strong>
              <span>{{ t.labels.colorVariants }}</span>
            </div>
          </div>
        </div>
      </section>

      <template v-else>
        <section class="project-bar">
          <div class="project-title-block">
            <div v-if="activeProject && editingProjectId === activeProject.id" class="project-rename">
              <n-input
                v-model:value="projectRenameDraft"
                :placeholder="t.placeholders.projectName"
                @keydown.enter="saveProjectRename(activeProject.id)"
                @keydown.esc="cancelProjectRename"
              />
              <button type="button" :aria-label="t.aria.saveProjectName" @click="saveProjectRename(activeProject.id)">
                <n-icon :component="CheckRound" />
              </button>
              <button type="button" :aria-label="t.aria.close" @click="cancelProjectRename">
                <n-icon :component="CloseRound" />
              </button>
            </div>
            <div v-else class="project-title-row">
              <h1>{{ activeProject?.name }}</h1>
              <button v-if="activeProject" type="button" class="project-rename-button" :aria-label="t.aria.renameProject" @click="startProjectRename(activeProject)">
                <n-icon :component="EditRound" />
              </button>
            </div>
            <p>{{ projectTotals.count }} {{ t.labels.ceilings.toLowerCase() }} · {{ formatCurrency(projectTotals.price) }}</p>
          </div>
        </section>

        <section v-if="viewMode === 'project-summary'" class="summary-layout">
          <div class="project-view-switch" :class="{ 'project-view-switch--visuals': projectSummaryView === 'visuals' }">
            <button type="button" :class="{ active: projectSummaryView === 'numbers' }" @click="projectSummaryView = 'numbers'">{{ t.labels.numbers }}</button>
            <button type="button" :class="{ active: projectSummaryView === 'visuals' }" @click="projectSummaryView = 'visuals'">{{ t.labels.visuals }}</button>
          </div>

          <div class="summary-panel" data-tour="project-totals">
            <div class="summary-card">
              <span>{{ t.labels.totalArea }}</span>
              <strong :class="{ changed: changedSummaryKey === 'area', 'changed-up': changedSummaryKey === 'area' && summaryChangeDirection === 'up', 'changed-down': changedSummaryKey === 'area' && summaryChangeDirection === 'down' }">{{ formatArea(projectTotals.area) }}</strong>
            </div>
            <div class="summary-card">
              <span>{{ t.labels.perimeter }}</span>
              <strong :class="{ changed: changedSummaryKey === 'perimeter', 'changed-up': changedSummaryKey === 'perimeter' && summaryChangeDirection === 'up', 'changed-down': changedSummaryKey === 'perimeter' && summaryChangeDirection === 'down' }">{{ formatNumber(projectTotals.perimeter) }} m</strong>
            </div>
            <div class="summary-card">
              <span>{{ t.labels.totalPrice }}</span>
              <strong :class="{ changed: changedSummaryKey === 'price', 'price-up': changedSummaryKey === 'price' && summaryChangeDirection === 'up', 'price-down': changedSummaryKey === 'price' && summaryChangeDirection === 'down' }">{{ formatCurrency(projectTotals.price) }}</strong>
            </div>
          </div>

          <transition name="summary-view" mode="out-in">
            <div v-if="projectSummaryView === 'numbers'" key="numbers" class="project-summary-content project-summary-content--numbers">
              <section class="builder-panel" data-tour="color-totals">
                <h2>{{ t.labels.byColor }}</h2>
                <div class="color-totals">
                  <div v-for="color in colorTotals" :key="color.colorName" class="color-total-row">
                    <span class="color-dot" :style="{ background: color.color }" />
                    <strong>{{ trColor(color.colorName) }}</strong>
                    <small>{{ formatArea(color.area) }} · {{ color.count }}</small>
                    <b>{{ formatCurrency(color.price) }}</b>
                  </div>
                  <p v-if="colorTotals.length === 0" class="empty-text">{{ t.empty.colors }}</p>
                </div>
              </section>

              <section class="builder-panel" data-tour="created-ceilings">
                <h2>{{ t.labels.ceilings }}</h2>
                <div class="ceiling-list">
                  <div v-for="ceiling in sortedCeilings" :key="ceiling.id" class="ceiling-row">
                    <button class="ceiling-open" type="button" @click="requestNavigation({ type: 'ceiling', ceilingId: ceiling.id })">
                      <span>{{ ceiling.name }} ({{ ceiling.corners }})</span>
                      <small>{{ trColor(selectedVariant(ceiling)?.colorName) }} · {{ formatArea(calculateArea(ceiling)) }}</small>
                      <b>{{ formatCurrency(calculatePrice(ceiling)) }}</b>
                    </button>
                    <button class="ceiling-delete" type="button" :aria-label="t.aria.deleteCeiling" @click="ceilingToDelete = ceiling"><n-icon :component="CloseRound" /></button>
                  </div>
                  <p v-if="sortedCeilings.length === 0" class="empty-text">{{ t.empty.ceilings }}</p>
                </div>
              </section>
            </div>

            <section v-else key="visuals" class="builder-panel visual-results project-summary-content">
              <div class="visual-results__header">
                <h2>{{ t.labels.selectedCeilings }}</h2>
                <span>{{ projectTotals.count }}</span>
              </div>
              <div class="visual-grid">
                <article v-for="ceiling in sortedCeilings" :key="ceiling.id" class="visual-card" @click="requestNavigation({ type: 'ceiling', ceilingId: ceiling.id })">
                  <svg viewBox="0 0 300 260" class="visual-card__preview" aria-hidden="true">
                    <polygon :points="getPolygonPoints(ceiling)" :fill="selectedVariant(ceiling)?.color || ceilingColors[0].value" stroke="#222" stroke-width="5" />
                    <g v-for="(point, index) in getPoints(ceiling)" :key="`${ceiling.id}-${index}`">
                      <circle :cx="point.x" :cy="point.y" r="12" fill="#ffffff" stroke="#222" stroke-width="2" />
                      <text :x="point.x" :y="point.y + 5" text-anchor="middle">{{ getCornerLabel(index) }}</text>
                    </g>
                  </svg>
                  <div class="visual-card__body">
                    <div>
                      <strong>{{ ceiling.name }} ({{ ceiling.corners }})</strong>
                      <small>{{ trColor(selectedVariant(ceiling)?.colorName) }}</small>
                    </div>
                    <div class="visual-card__stats">
                      <span>{{ formatArea(calculateArea(ceiling)) }}</span>
                      <b>{{ formatCurrency(calculatePrice(ceiling)) }}</b>
                    </div>
                  </div>
                </article>
                <p v-if="sortedCeilings.length === 0" class="empty-text">{{ t.empty.visuals }}</p>
              </div>
            </section>
          </transition>
        </section>

        <section v-if="activeCeiling && (viewMode === 'ceiling-edit' || viewMode === 'ceiling-view')" class="builder-grid" :class="{ 'builder-grid--preview': viewMode === 'ceiling-view' }">
          <transition name="panel-fade">
            <div v-if="viewMode === 'ceiling-edit'" class="builder-panel builder-tool">
              <div class="builder-form-row">
                <label class="builder-field" data-tour="ceiling-name">
                  <span>{{ t.labels.name }}</span>
                  <n-input :value="activeCeiling.name" @update:value="updateCeilingName" />
                </label>
                <div class="builder-field builder-field--corners" data-tour="ceiling-corners" :class="{ changed: isCornersChanged }">
                  <span>{{ t.labels.corners }}</span>
                  <n-input-number :value="activeCeiling.corners" :min="minCorners" :max="maxCorners" :step="1" button-placement="both" @update:value="changeCorners" />
                </div>
                <div class="builder-field builder-field--color" data-tour="main-color">
                  <span>{{ t.labels.color }}</span>
                  <n-popover :show="activeColorPickerKey === 'main'" trigger="click" placement="bottom" :show-arrow="false" @update:show="activeColorPickerKey = $event ? 'main' : null">
                    <template #trigger>
                      <button class="color-select-button" type="button">
                        <span :style="{ background: activeVariant?.color || ceilingColors[0].value }" />
                      </button>
                    </template>
                    <div class="color-grid">
                      <button v-for="color in ceilingColors" :key="color.value" class="color-option" type="button" :style="{ background: color.value }" :aria-label="trColor(color.label)" @click="changeVariantColor(color)" />
                    </div>
                  </n-popover>
                </div>
                <div class="builder-field builder-field--view" data-tour="full-view">
                  <span>{{ t.labels.view }}</span>
                  <n-button secondary class="preview-toggle" @click="requestNavigation({ type: 'ceiling-view' })">{{ t.actions.full }}</n-button>
                </div>
              </div>
              <transition-group name="side-row-motion" tag="div" class="side-list">
                <label v-for="(_, index) in activeCeiling.sides" :key="index" class="side-row" :data-tour="index === 0 ? 'side-length' : undefined">
                  <span>{{ labels[index] }}-{{ labels[(index + 1) % activeCeiling.corners] }}</span>
                  <div class="side-stepper" :class="{ changed: changedSideIndex === index, 'changed-up': changedSideIndex === index && sideChangeDirection === 'up', 'changed-down': changedSideIndex === index && sideChangeDirection === 'down' }">
                    <button type="button" :aria-label="t.aria.decreaseLength" @click="updateSide(index, -0.1)"><n-icon :component="RemoveRound" /></button>
                    <input :value="activeCeiling.sides[index]" type="number" min="0.2" step="0.1" @input="setSide(index, Number(($event.target as HTMLInputElement).value))">
                    <button type="button" :aria-label="t.aria.increaseLength" @click="updateSide(index, 0.1)"><n-icon :component="AddRound" /></button>
                  </div>
                  <small>m</small>
                </label>
              </transition-group>
            </div>
          </transition>

          <div class="builder-panel preview-panel" data-tour="ceiling-preview" :class="{ 'preview-panel--expanded': viewMode === 'ceiling-view' }">
            <div v-if="viewMode === 'ceiling-view'" class="preview-actions">
              <div class="preview-actions__group">
                <n-button secondary @click="editCeiling">{{ t.actions.edit }}</n-button>
                <n-button type="error" secondary @click="ceilingToDelete = activeCeiling">{{ t.actions.delete }}</n-button>
              </div>
            </div>
            <svg viewBox="0 0 300 260" class="ceiling-preview" :class="{ 'corners-up': isCornersChanged && cornersChangeDirection === 'up', 'corners-down': isCornersChanged && cornersChangeDirection === 'down' }" role="img" :aria-label="t.aria.preview">
              <polygon :points="polygonPoints" :fill="activeVariant?.color || '#f7f4ef'" stroke="#222" stroke-width="3" />
              <g v-for="(point, index) in getPoints(activeCeiling)" :key="labels[index]">
                <circle :cx="point.x" :cy="point.y" r="14" fill="#ffffff" stroke="#222" stroke-width="2" />
                <text :x="point.x" :y="point.y + 5" text-anchor="middle">{{ labels[index] }}</text>
              </g>
            </svg>
          </div>

          <transition name="panel-fade">
            <div v-if="viewMode === 'ceiling-edit'" class="summary-panel" data-tour="ceiling-result">
              <div class="summary-card"><span>{{ t.labels.area }}</span><strong>{{ formatArea(area) }}</strong></div>
              <div class="summary-card"><span>{{ t.labels.perimeter }}</span><strong>{{ formatNumber(perimeter) }} m</strong></div>
              <div class="summary-card"><span>{{ t.labels.price }}</span><strong>{{ formatCurrency(price) }}</strong></div>
            </div>
          </transition>

          <transition name="panel-fade">
            <section v-if="viewMode === 'ceiling-edit'" class="builder-panel variants-panel">
              <div class="variants-header">
                <h2>{{ t.labels.colors }}</h2>
                <n-button secondary data-tour="add-color-variant" @click="addVariant">{{ t.actions.addVariant }}</n-button>
              </div>
              <div class="variants-list">
                <article v-for="variant in sortedVariants" :key="variant.id" class="variant-card" :class="{ active: variant.id === activeCeiling.activeVariantId }">
                  <button class="variant-preview" type="button" @click="selectVariant(variant)">
                    <svg viewBox="0 0 300 260" aria-hidden="true"><polygon :points="polygonPoints" :fill="variant.color" stroke="#222" stroke-width="5" /></svg>
                  </button>
                  <div class="variant-meta">
                    <strong>{{ trColor(variant.colorName) }}</strong>
                    <small>{{ variant.isFavorite ? t.labels.selectedForTotal : t.labels.colorOption }}</small>
                  </div>
                  <div class="variant-actions">
                    <n-popover :show="activeColorPickerKey === `variant-${variant.id}`" trigger="click" placement="top" :show-arrow="false" @update:show="activeColorPickerKey = $event ? `variant-${variant.id}` : null">
                      <template #trigger><n-button secondary size="small" @click="selectVariant(variant)">{{ t.actions.color }}</n-button></template>
                      <div class="color-grid">
                        <button v-for="color in ceilingColors" :key="color.value" class="color-option" type="button" :style="{ background: color.value }" :aria-label="trColor(color.label)" @click="changeVariantColor(color)" />
                      </div>
                    </n-popover>
                    <n-button secondary size="small" @click="toggleFavorite(variant)">
                      <n-icon :component="variant.isFavorite ? StarRound : StarBorderRound" />
                    </n-button>
                    <n-button type="error" secondary size="small" @click="deleteVariant(variant)">
                      <n-icon :component="CloseRound" />
                    </n-button>
                  </div>
                </article>
              </div>
            </section>
          </transition>
        </section>
      </template>
    </main>

    <transition name="save-float">
      <n-button v-if="shouldShowSave" type="primary" circle size="large" class="floating-save" data-tour="save-ceiling" :title="t.actions.save" @click="saveCurrentCeiling">
        <n-icon :component="CheckRound" />
      </n-button>
    </transition>

    <transition name="save-float">
      <button v-if="viewMode === 'project-create'" class="create-fab" type="button" @click="createProject">
        <n-icon :component="HouseRound" />
        <span>{{ t.labels.house }}</span>
      </button>
      <button v-else-if="viewMode === 'project-summary'" class="create-fab" type="button" data-tour="new-ceiling" @click="requestNavigation({ type: 'new-ceiling' })">
        <n-icon :component="AddRound" />
        <span>{{ t.labels.ceiling }}</span>
      </button>
    </transition>

    <n-drawer v-model:show="isProjectsDrawerOpen" placement="right" :width="320">
      <n-drawer-content :title="t.actions.projects" closable>
        <div class="projects-drawer">
          <div v-for="project in sortedProjects" :key="project.id" class="project-drawer-item">
            <div v-if="editingProjectId === project.id" class="project-drawer-rename">
              <n-input
                v-model:value="projectRenameDraft"
                :placeholder="t.placeholders.projectName"
                @keydown.enter="saveProjectRename(project.id)"
                @keydown.esc="cancelProjectRename"
              />
              <button type="button" :aria-label="t.aria.saveProjectName" @click="saveProjectRename(project.id)">
                <n-icon :component="CheckRound" />
              </button>
              <button type="button" :aria-label="t.aria.close" @click="cancelProjectRename">
                <n-icon :component="CloseRound" />
              </button>
            </div>
            <button v-else class="project-drawer-row" :class="{ active: project.id === activeProjectId }" type="button" @click="requestNavigation({ type: 'project', projectId: project.id })">
              <span>{{ project.name }}</span>
              <small>{{ project.ceilings.length }} {{ t.labels.ceilings.toLowerCase() }} · {{ formatDate(project.createdAt) }}</small>
            </button>
            <button v-if="editingProjectId !== project.id" class="project-icon-button" type="button" :aria-label="t.aria.renameProject" @click="startProjectRename(project)"><n-icon :component="EditRound" /></button>
            <button class="ceiling-delete" type="button" :aria-label="t.aria.deleteProject" @click="projectToDelete = project"><n-icon :component="CloseRound" /></button>
          </div>
          <p v-if="sortedProjects.length === 0" class="empty-text">{{ t.empty.projects }}</p>
          <button class="drawer-create-button" type="button" @click="requestNavigation({ type: 'new-project' })">
            <n-icon :component="DomainAddRound" />
            <span>{{ t.labels.newProject }}</span>
          </button>
        </div>
      </n-drawer-content>
    </n-drawer>

    <n-drawer v-model:show="isCeilingsDrawerOpen" placement="right" :width="320">
      <n-drawer-content :title="t.labels.ceilings" closable>
        <div class="projects-drawer">
          <n-button type="primary" secondary @click="requestNavigation({ type: 'new-ceiling' })">{{ t.labels.newCeiling }}</n-button>
          <button v-for="ceiling in sortedCeilings" :key="ceiling.id" class="project-drawer-row" :class="{ active: ceiling.id === activeCeilingId }" @click="requestNavigation({ type: 'ceiling', ceilingId: ceiling.id })">
            <span>{{ ceiling.name }} ({{ ceiling.corners }})</span>
            <small>{{ trColor(selectedVariant(ceiling)?.colorName) }} · {{ formatCurrency(calculatePrice(ceiling)) }}</small>
          </button>
        </div>
      </n-drawer-content>
    </n-drawer>

    <n-modal v-model:show="isUnsavedModalOpen" preset="dialog" :title="t.modal.unsavedTitle">
      <p class="delete-copy">{{ t.modal.unsavedCopy }}</p>
      <template #action>
        <n-button @click="pendingNavigation = null">{{ t.actions.cancel }}</n-button>
        <n-button secondary @click="discardAndContinue">{{ t.actions.discard }}</n-button>
        <n-button type="primary" @click="saveAndContinue">{{ t.actions.save }}</n-button>
      </template>
    </n-modal>

    <n-modal v-model:show="isCeilingDeleteOpen" preset="dialog" :title="t.modal.ceilingDeleteTitle">
      <p class="delete-copy">{{ t.modal.ceilingDeleteCopy }}</p>
      <template #action>
        <n-button @click="ceilingToDelete = null">{{ t.actions.cancel }}</n-button>
        <n-button type="error" @click="confirmDeleteCeiling">{{ t.actions.delete }}</n-button>
      </template>
    </n-modal>

    <n-modal v-model:show="isProjectDeleteOpen" preset="dialog" :title="t.modal.projectDeleteTitle">
      <p class="delete-copy">{{ t.modal.projectDeleteCopy }}</p>
      <template #action>
        <n-button @click="projectToDelete = null">{{ t.actions.cancel }}</n-button>
        <n-button type="error" @click="confirmDeleteProject">{{ t.actions.delete }}</n-button>
      </template>
    </n-modal>
  </div>
</template>

<style scoped>
.builder-page {
  min-height: 100vh;
  background:
    radial-gradient(circle at 18% 8%, rgba(180, 20, 40, 0.08), transparent 26%),
    linear-gradient(180deg, #f8f9fb 0%, #eef1f5 100%);
  color: #202124;
  font-family: "Helvetica Neue", Arial, sans-serif;
}

.builder-page :deep(.n-button:not(.n-button--circle)),
:global(.n-dialog .n-button:not(.n-button--circle)) {
  border-radius: 12px;
  background-image: linear-gradient(180deg, rgba(255, 255, 255, 0.34), rgba(255, 255, 255, 0));
  box-shadow: 0 8px 18px rgba(30, 34, 42, 0.08), inset 0 1px 0 rgba(255, 255, 255, 0.45);
}

.builder-page :deep(.n-button.n-button--circle) {
  border-radius: 999px;
  background-image: linear-gradient(145deg, rgba(255, 255, 255, 0.45), rgba(255, 255, 255, 0.02));
  box-shadow: 0 10px 22px rgba(30, 34, 42, 0.13), inset 0 1px 0 rgba(255, 255, 255, 0.5);
}

.notifications {
  position: fixed;
  top: max(10px, env(safe-area-inset-top));
  right: max(10px, env(safe-area-inset-right));
  z-index: 30;
  display: grid;
  gap: 8px;
  width: min(280px, calc(100vw - 20px));
  pointer-events: none;
}

.notification {
  padding: 10px 12px;
  border-radius: 12px;
  color: #ffffff;
  font-size: 13px;
  font-weight: 700;
  box-shadow: 0 10px 24px rgba(30, 34, 42, 0.18);
}

.notification--success { background: #16834b; }
.notification--error { background: #b42318; }

.builder-top {
  position: sticky;
  top: 0;
  z-index: 5;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  padding: 12px max(18px, env(safe-area-inset-right)) 12px max(18px, env(safe-area-inset-left));
  background: rgba(255, 255, 255, 0.92);
  border-bottom: 1px solid #e1e4ea;
  backdrop-filter: blur(14px);
}

.builder-logo {
  width: 118px;
  height: 42px;
  object-fit: contain;
}

.top-actions {
  display: flex;
  align-items: center;
  gap: 8px;
}

.builder-lang { width: 104px; }

.builder-shell {
  width: min(1120px, 100%);
  margin: 0 auto;
  padding: 14px 14px 92px;
}

.builder-shell--with-fab {
  padding-bottom: 132px;
}

.local-notice {
  position: fixed;
  left: max(14px, env(safe-area-inset-left));
  right: max(14px, env(safe-area-inset-right));
  bottom: max(12px, env(safe-area-inset-bottom));
  z-index: 35;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 10px;
  width: min(520px, 100%);
  margin: 0 auto;
  padding: 9px 10px 9px 12px;
  background: rgba(255, 248, 230, 0.9);
  border: 1px solid #f0d48a;
  border-radius: 14px;
  color: #5f4813;
  font-size: 13px;
  font-weight: 700;
  box-shadow: 0 10px 24px rgba(95, 72, 19, 0.08);
}

.local-notice button {
  width: 28px;
  height: 28px;
  border: 0;
  border-radius: 999px;
  background: rgba(95, 72, 19, 0.1);
  cursor: pointer;
  font-weight: 800;
}

.local-notice button .n-icon {
  font-size: 18px;
}

.breadcrumbs {
  display: flex;
  align-items: center;
  gap: 6px;
  flex-wrap: wrap;
  margin-bottom: 10px;
  color: #707782;
}

.breadcrumbs button,
.breadcrumbs__current {
  min-height: 32px;
  display: inline-flex;
  align-items: center;
  padding: 6px 10px;
  background: linear-gradient(180deg, #ffffff, #f5f7fa);
  border: 1px solid #d8dce3;
  border-radius: 999px;
  color: #2f343c;
  box-shadow: 0 7px 15px rgba(30, 34, 42, 0.07), inset 0 1px 0 rgba(255, 255, 255, 0.72);
  font-weight: 800;
}

.breadcrumbs button {
  cursor: pointer;
}

.breadcrumbs button:active {
  transform: translateY(1px);
}

.breadcrumbs__current {
  color: #6a717d;
}

.breadcrumbs span {
  color: #9aa1ad;
  font-weight: 800;
}

.builder-panel {
  background: #ffffff;
  border: 1px solid #d8dce3;
  border-radius: 12px;
  box-shadow: 0 8px 18px rgba(30, 34, 42, 0.06), inset 0 1px 0 rgba(255, 255, 255, 0.72);
}

.create-screen {
  min-height: calc(100vh - 190px);
  display: grid;
  place-items: start center;
  padding-top: 18px;
}

.create-card {
  display: grid;
  gap: 14px;
  width: min(520px, 100%);
  padding: 18px;
  background:
    linear-gradient(180deg, rgba(255, 255, 255, 0.96), rgba(255, 255, 255, 0.86)),
    radial-gradient(circle at 100% 0%, rgba(180, 20, 40, 0.1), transparent 32%);
  border: 1px solid rgba(216, 220, 227, 0.9);
  border-radius: 18px;
  box-shadow: 0 22px 50px rgba(30, 34, 42, 0.12), inset 0 1px 0 rgba(255, 255, 255, 0.74);
}

.create-card__header {
  display: grid;
  gap: 6px;
}

.create-badge {
  width: fit-content;
  padding: 5px 9px;
  background: rgba(180, 20, 40, 0.08);
  border: 1px solid rgba(180, 20, 40, 0.16);
  border-radius: 999px;
  color: #b41428;
  font-size: 12px;
  font-weight: 800;
}

.create-card h1 {
  font-size: 32px;
}

.create-card p {
  font-size: 15px;
}

.create-field {
  display: grid;
  gap: 7px;
  color: #4a515c;
  font-size: 13px;
  font-weight: 800;
}

.create-field :deep(.n-input) {
  --n-height: 48px !important;
}

.create-button {
  width: min(180px, 100%);
}

.create-preview {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 8px;
  padding-top: 2px;
}

.create-preview div,
.create-preview button {
  display: grid;
  gap: 2px;
  padding: 10px;
  background: #f7f8fa;
  border: 1px solid #e0e3e9;
  border-radius: 14px;
  color: inherit;
  text-align: left;
}

.create-preview button {
  cursor: pointer;
}

.create-preview button:active {
  transform: translateY(1px);
}

.create-preview strong {
  display: inline-flex;
  align-items: center;
  color: #b41428;
  font-size: 20px;
  line-height: 1;
}

.create-preview span {
  color: #5c6370;
  font-size: 12px;
  font-weight: 700;
}

h1, h2, p { margin: 0; }
h1 { font-size: 24px; line-height: 1.15; }
h2 { font-size: 16px; }
p { color: #5c6370; }

.project-bar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  padding: 6px 0 10px;
  border-bottom: 1px solid #d4d8df;
}

.project-bar p {
  margin-top: 2px;
  font-size: 13px;
}

.project-title-block {
  min-width: 0;
}

.project-title-row,
.project-rename,
.project-drawer-rename {
  display: flex;
  align-items: center;
  gap: 8px;
  min-width: 0;
}

.project-title-row h1 {
  min-width: 0;
  overflow-wrap: anywhere;
}

.project-rename {
  width: min(520px, calc(100vw - 28px));
}

.project-drawer-rename {
  min-width: 0;
}

.project-rename :deep(.n-input),
.project-drawer-rename :deep(.n-input) {
  flex: 1 1 auto;
  min-width: 0;
}

.project-rename button,
.project-drawer-rename button,
.project-rename-button,
.project-icon-button {
  flex: 0 0 auto;
  width: 34px;
  height: 34px;
  border: 1px solid #cfd5df;
  border-radius: 999px;
  background: linear-gradient(145deg, #ffffff, #f2f5f9);
  color: #384150;
  cursor: pointer;
  font-size: 16px;
  font-weight: 900;
  box-shadow: 0 7px 15px rgba(30, 34, 42, 0.08), inset 0 1px 0 rgba(255, 255, 255, 0.72);
}

.project-rename button .n-icon,
.project-drawer-rename button .n-icon,
.project-rename-button .n-icon,
.project-icon-button .n-icon {
  font-size: 20px;
}

.bar-actions {
  display: flex;
  gap: 8px;
}

.summary-layout,
.builder-grid {
  display: grid;
  grid-template-columns: minmax(300px, 0.9fr) minmax(320px, 1.1fr);
  gap: 10px;
  padding-top: 10px;
}

.builder-grid--preview { grid-template-columns: 1fr; }

.builder-panel {
  padding: 12px;
}

.project-view-switch {
  grid-column: 1 / -1;
  position: relative;
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 6px;
  width: min(360px, 100%);
  padding: 5px;
  background: #e9edf3;
  border: 1px solid #d3d8e0;
  border-radius: 999px;
  box-shadow: inset 0 1px 2px rgba(30, 34, 42, 0.08);
}

.project-view-switch::before {
  content: "";
  position: absolute;
  top: 5px;
  left: 5px;
  width: calc(50% - 8px);
  height: calc(100% - 10px);
  border-radius: 999px;
  background: linear-gradient(180deg, #ffffff, #f8f9fb);
  box-shadow: 0 8px 16px rgba(30, 34, 42, 0.1), inset 0 1px 0 rgba(255, 255, 255, 0.72);
  transition: transform 0.28s cubic-bezier(0.2, 0.8, 0.2, 1);
}

.project-view-switch--visuals::before {
  transform: translateX(calc(100% + 6px));
}

.project-view-switch button {
  position: relative;
  z-index: 1;
  min-height: 36px;
  border: 0;
  border-radius: 999px;
  background: transparent;
  color: #5f6672;
  font-size: 14px;
  font-weight: 900;
  cursor: pointer;
  transition: color 0.2s ease, transform 0.2s ease;
}

.project-view-switch button.active {
  color: #202124;
}

.project-view-switch button:active {
  transform: scale(0.98);
}

.project-summary-content {
  grid-column: 1 / -1;
  min-height: 260px;
}

.project-summary-content--numbers {
  display: grid;
  grid-template-columns: minmax(300px, 0.9fr) minmax(320px, 1.1fr);
  gap: 10px;
}

.summary-view-enter-active,
.summary-view-leave-active {
  transition: opacity 0.22s ease, transform 0.22s ease, filter 0.22s ease;
}

.summary-view-enter-from {
  opacity: 0;
  transform: translateY(8px);
  filter: blur(3px);
}

.summary-view-leave-to {
  opacity: 0;
  transform: translateY(-6px);
  filter: blur(2px);
}

.summary-panel {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 8px;
  grid-column: 1 / -1;
}

.summary-card {
  display: grid;
  gap: 2px;
  padding: 10px;
  background: #ffffff;
  border: 1px solid #d8dce3;
  border-radius: 12px;
}

.summary-card span,
.summary-card small {
  color: #5c6370;
  font-size: 12px;
}

.summary-card strong {
  display: inline-block;
  font-size: 18px;
  font-variant-numeric: tabular-nums;
}

.summary-card strong.changed { animation: number-roll 0.46s ease; }
.summary-card strong.changed-up { color: #16834b; text-shadow: 0 5px 18px rgba(22, 131, 75, 0.16); }
.summary-card strong.changed-down { color: #b42318; text-shadow: 0 5px 18px rgba(180, 35, 24, 0.16); }
.summary-card strong.price-up { color: #b42318; text-shadow: 0 5px 18px rgba(180, 35, 24, 0.16); }
.summary-card strong.price-down { color: #16834b; text-shadow: 0 5px 18px rgba(22, 131, 75, 0.16); }

.color-totals,
.ceiling-list,
.projects-drawer {
  display: grid;
  gap: 10px;
}

.projects-drawer { padding-bottom: 76px; }

.color-total-row,
.ceiling-row,
.project-drawer-row {
  display: grid;
  gap: 4px;
  width: 100%;
  padding: 12px;
  background: linear-gradient(180deg, #ffffff, #f8f9fb);
  border: 1px solid #d8dce3;
  border-radius: 12px;
  color: #2f343c;
  text-align: left;
  cursor: pointer;
  box-shadow: 0 8px 18px rgba(30, 34, 42, 0.07), inset 0 1px 0 rgba(255, 255, 255, 0.72);
}

.ceiling-row {
  grid-template-columns: minmax(0, 1fr) 34px;
  align-items: center;
  gap: 8px;
}

.project-drawer-item {
  display: grid;
  grid-template-columns: minmax(0, 1fr) 34px 34px;
  align-items: center;
  gap: 8px;
}

.ceiling-open {
  display: grid;
  gap: 4px;
  min-width: 0;
  padding: 0;
  background: transparent;
  border: 0;
  color: inherit;
  text-align: left;
  cursor: pointer;
}

.ceiling-delete {
  width: 34px;
  height: 34px;
  border: 1px solid #e4b5b0;
  border-radius: 999px;
  background: linear-gradient(145deg, #ffffff, #fff1f0);
  color: #b42318;
  font-size: 16px;
  font-weight: 900;
  cursor: pointer;
  box-shadow: 0 7px 15px rgba(180, 35, 24, 0.08), inset 0 1px 0 rgba(255, 255, 255, 0.72);
}

.ceiling-delete .n-icon {
  font-size: 20px;
}

.color-total-row {
  grid-template-columns: 28px 1fr auto auto;
  align-items: center;
  cursor: default;
}

.color-dot {
  width: 24px;
  height: 24px;
  border: 1px solid #cfd4dc;
  border-radius: 999px;
}

.ceiling-row span,
.project-drawer-row span {
  font-size: 15px;
  font-weight: 800;
}

.ceiling-row small,
.project-drawer-row small,
.empty-text {
  color: #6d7480;
  font-size: 12px;
}

.project-drawer-row.active {
  border-color: #b41428;
  box-shadow: 0 0 0 2px rgba(180, 20, 40, 0.1);
}

.drawer-create-button {
  position: sticky;
  bottom: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  width: 100%;
  min-height: 48px;
  margin-top: 6px;
  border: 1px solid rgba(180, 20, 40, 0.24);
  border-radius: 14px;
  background: linear-gradient(180deg, #c9273b, #a91124);
  color: #ffffff;
  font-size: 15px;
  font-weight: 900;
  cursor: pointer;
  box-shadow: 0 14px 28px rgba(180, 20, 40, 0.24), inset 0 1px 0 rgba(255, 255, 255, 0.24);
}

.drawer-create-button .n-icon {
  font-size: 22px;
}

.builder-form-row {
  display: grid;
  grid-template-columns: minmax(0, 1fr) 112px 54px 64px;
  gap: 8px;
}

.builder-field {
  display: grid;
  gap: 6px;
  margin-bottom: 10px;
  color: #4a515c;
  font-weight: 700;
  font-size: 13px;
}

.builder-field--corners.changed { animation: value-change 0.52s ease; }
.builder-field--corners.changed :deep(.n-input) { box-shadow: 0 0 0 3px rgba(180, 20, 40, 0.12); }
.preview-toggle { width: 100%; }

.color-select-button {
  width: 100%;
  height: 34px;
  display: grid;
  place-items: center;
  padding: 0;
  border: 1px solid #cfd4dc;
  border-radius: 12px;
  background: linear-gradient(180deg, #ffffff, #f3f5f8);
  cursor: pointer;
  box-shadow: 0 7px 15px rgba(30, 34, 42, 0.08), inset 0 1px 0 rgba(255, 255, 255, 0.72);
}

.color-select-button span {
  width: 24px;
  height: 24px;
  border: 1px solid #b9c0ca;
  border-radius: 999px;
  box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.48), 0 4px 10px rgba(30, 34, 42, 0.12);
}

.side-list {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 6px;
  max-height: 320px;
  overflow: auto;
  padding-right: 2px;
}

.side-row {
  display: grid;
  grid-template-columns: 48px minmax(0, 1fr) 18px;
  align-items: center;
  gap: 6px;
}

.side-row span {
  font-weight: 700;
  font-size: 13px;
}

.side-stepper {
  display: grid;
  grid-template-columns: 34px minmax(44px, 1fr) 34px;
  align-items: center;
  gap: 4px;
}

.side-stepper button,
.color-option,
.color-dot {
  box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.42), 0 5px 12px rgba(30, 34, 42, 0.1);
}

.side-stepper button {
  width: 34px;
  height: 34px;
  display: grid;
  place-items: center;
  border: 1px solid #cfd4dc;
  border-radius: 999px;
  background: linear-gradient(145deg, #ffffff, #f2f4f7);
  color: #2f343c;
  cursor: pointer;
}

.side-stepper button:active { transform: scale(0.92); }
.side-stepper button .n-icon { font-size: 20px; }

.side-stepper input {
  width: 100%;
  height: 34px;
  padding: 0 4px;
  border: 1px solid #d8dce3;
  border-radius: 12px;
  background: #ffffff;
  color: #202124;
  font-size: 14px;
  font-weight: 800;
  text-align: center;
  transition: border-color 0.18s ease, box-shadow 0.18s ease, background 0.18s ease;
}

.side-stepper.changed { animation: value-change 0.52s ease; }
.side-stepper.changed-up input { border-color: #16834b; background: #f2fbf6; box-shadow: 0 0 0 3px rgba(22, 131, 75, 0.12); animation: value-up 0.52s ease; }
.side-stepper.changed-down input { border-color: #b42318; background: #fff7f6; box-shadow: 0 0 0 3px rgba(180, 35, 24, 0.12); animation: value-down 0.52s ease; }
.side-stepper input::-webkit-inner-spin-button,
.side-stepper input::-webkit-outer-spin-button { margin: 0; appearance: none; }

.preview-panel {
  display: grid;
  gap: 8px;
  align-content: start;
}

.preview-panel--expanded { min-height: calc(100vh - 118px); }
.preview-actions {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 8px;
  flex-wrap: wrap;
}

.preview-actions__group {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
}

.ceiling-preview,
.variant-preview {
  width: 100%;
  background:
    linear-gradient(#edf0f4 1px, transparent 1px),
    linear-gradient(90deg, #edf0f4 1px, transparent 1px);
  background-size: 24px 24px;
  border: 1px solid #d8dce3;
  border-radius: 12px;
}

.ceiling-preview {
  aspect-ratio: 1.2;
  max-height: 300px;
}

.preview-panel--expanded .ceiling-preview {
  height: auto;
  max-height: calc(100vh - 176px);
  animation: preview-pop 0.28s ease both;
}

.ceiling-preview.corners-up { animation: ceiling-corners-up 0.42s ease; }
.ceiling-preview.corners-down { animation: ceiling-corners-down 0.42s ease; }
.ceiling-preview text { font-size: 15px; font-weight: 800; }

.variants-panel {
  display: grid;
  gap: 10px;
  grid-column: 1 / -1;
}

.variants-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 10px;
}

.variants-list {
  display: grid;
  grid-auto-flow: column;
  grid-auto-columns: minmax(174px, 210px);
  gap: 10px;
  overflow-x: auto;
  padding-bottom: 2px;
}

.variant-card {
  display: grid;
  gap: 8px;
  padding: 10px;
  background: linear-gradient(180deg, #ffffff, #f8f9fb);
  border: 1px solid #d8dce3;
  border-radius: 12px;
  box-shadow: 0 8px 18px rgba(30, 34, 42, 0.07), inset 0 1px 0 rgba(255, 255, 255, 0.72);
}

.variant-card.active {
  border-color: #b41428;
  box-shadow: 0 0 0 2px rgba(180, 20, 40, 0.1);
}

.variant-preview {
  aspect-ratio: 1.55;
  padding: 0;
  overflow: hidden;
  cursor: pointer;
}

.variant-preview svg { width: 100%; height: 100%; }
.variant-meta { display: grid; gap: 2px; }
.variant-meta strong { font-size: 14px; }
.variant-meta small { color: #5c6370; font-size: 12px; }
.variant-actions { display: grid; grid-template-columns: 1fr 42px 42px; gap: 6px; }

.color-grid {
  display: grid;
  grid-template-columns: repeat(5, 28px);
  gap: 7px;
  padding: 2px;
}

.color-option {
  width: 28px;
  height: 28px;
  border: 1px solid #cfd4dc;
  border-radius: 999px;
  cursor: pointer;
}

.visual-results {
  grid-column: 1 / -1;
  display: grid;
  gap: 12px;
}

.visual-results__header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 10px;
}

.visual-results__header span {
  min-width: 34px;
  height: 34px;
  display: grid;
  place-items: center;
  border-radius: 999px;
  background: #f2f4f7;
  color: #5f6672;
  font-weight: 900;
}

.visual-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
  gap: 10px;
}

.visual-card {
  display: grid;
  gap: 10px;
  padding: 10px;
  background: linear-gradient(180deg, #ffffff, #f8f9fb);
  border: 1px solid #d8dce3;
  border-radius: 14px;
  cursor: pointer;
  box-shadow: 0 9px 20px rgba(30, 34, 42, 0.08), inset 0 1px 0 rgba(255, 255, 255, 0.72);
}

.visual-card:active {
  transform: translateY(1px);
}

.visual-card__preview {
  width: 100%;
  aspect-ratio: 1.45;
  background:
    linear-gradient(#edf0f4 1px, transparent 1px),
    linear-gradient(90deg, #edf0f4 1px, transparent 1px);
  background-size: 22px 22px;
  border: 1px solid #d8dce3;
  border-radius: 12px;
}

.visual-card__preview text {
  font-size: 14px;
  font-weight: 900;
}

.visual-card__body {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 10px;
}

.visual-card__body div {
  display: grid;
  gap: 2px;
}

.visual-card__body strong {
  color: #2f343c;
  font-size: 15px;
}

.visual-card__body small,
.visual-card__stats span {
  color: #6d7480;
  font-size: 12px;
  font-weight: 800;
}

.visual-card__stats {
  text-align: right;
}

.visual-card__stats b {
  color: #202124;
  font-size: 14px;
}

.floating-save {
  position: fixed;
  top: max(112px, calc(env(safe-area-inset-top, 0px) + 112px));
  right: max(12px, env(safe-area-inset-right));
  z-index: 20;
  width: 46px;
  height: 46px;
  font-size: 20px;
  font-weight: 800;
  box-shadow: 0 12px 28px rgba(30, 34, 42, 0.22), inset 0 1px 0 rgba(255, 255, 255, 0.45);
}

.create-fab {
  position: fixed;
  right: max(16px, env(safe-area-inset-right));
  bottom: max(16px, env(safe-area-inset-bottom));
  z-index: 18;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 9px;
  min-width: 156px;
  min-height: 50px;
  padding: 0 18px;
  border: 1px solid rgba(180, 20, 40, 0.28);
  border-radius: 999px;
  background: linear-gradient(180deg, rgba(201, 39, 59, 0.88), rgba(169, 17, 36, 0.82));
  color: #ffffff;
  font-size: 15px;
  font-weight: 900;
  cursor: pointer;
  backdrop-filter: blur(12px);
  box-shadow: 0 14px 28px rgba(180, 20, 40, 0.2), inset 0 1px 0 rgba(255, 255, 255, 0.3);
}

.builder-page--with-local-notice .create-fab {
  bottom: max(78px, calc(env(safe-area-inset-bottom) + 78px));
}

.create-fab .n-icon {
  font-size: 22px;
}

.create-fab:active {
  transform: translateY(1px);
}

.delete-copy { color: #5c6370; }

.panel-fade-enter-active,
.panel-fade-leave-active,
.side-row-motion-move,
.side-row-motion-enter-active,
.side-row-motion-leave-active,
.save-float-enter-active,
.save-float-leave-active {
  transition: opacity 0.22s ease, transform 0.22s ease;
}

.panel-fade-enter-from,
.panel-fade-leave-to,
.side-row-motion-enter-from,
.side-row-motion-leave-to,
.save-float-enter-from,
.save-float-leave-to {
  opacity: 0;
  transform: translateY(8px);
}

.side-row-motion-leave-active { position: absolute; width: calc(50% - 3px); }

@keyframes value-change {
  0% { filter: brightness(1); }
  38% { filter: brightness(0.98); }
  100% { filter: brightness(1); }
}

@keyframes value-up {
  0% { transform: translateX(0); }
  34% { transform: translateX(3px); }
  100% { transform: translateX(0); }
}

@keyframes value-down {
  0% { transform: translateX(0); }
  34% { transform: translateX(-3px); }
  100% { transform: translateX(0); }
}

@keyframes number-roll {
  0% { opacity: 0.72; transform: translateY(3px); }
  45% { opacity: 1; transform: translateY(-2px); }
  100% { opacity: 1; transform: translateY(0); }
}

@keyframes preview-pop {
  from { opacity: 0.72; transform: scale(0.985); }
  to { opacity: 1; transform: scale(1); }
}

@keyframes ceiling-corners-up {
  0% { transform: translateY(6px); filter: brightness(0.98); }
  55% { transform: translateY(-3px); }
  100% { transform: translateY(0); filter: brightness(1); }
}

@keyframes ceiling-corners-down {
  0% { transform: translateY(-6px); filter: brightness(0.98); }
  55% { transform: translateY(3px); }
  100% { transform: translateY(0); filter: brightness(1); }
}

@media (max-width: 780px) {
  .project-bar {
    align-items: stretch;
    flex-direction: column;
  }

  .builder-top {
    align-items: center;
  }

  .top-actions,
  .bar-actions {
    display: grid;
    grid-template-columns: 1fr 1fr;
  }

  .builder-lang { width: 100%; grid-column: 1 / -1; }
  .summary-layout,
  .builder-grid { grid-template-columns: 1fr; }
  .project-summary-content--numbers { grid-template-columns: 1fr; }
  .builder-form-row { grid-template-columns: minmax(0, 1fr) 104px 54px 60px; }
}

@media (max-width: 430px) {
  .builder-top {
    padding: 10px;
  }

  .builder-logo {
    width: 82px;
    height: 34px;
  }

  .top-actions {
    flex: 1 1 auto;
    grid-template-columns: 1fr 1fr;
    gap: 6px;
  }

  .top-actions :deep(.n-button) {
    min-width: 0;
    padding: 0 10px;
  }

  .builder-shell { padding: 10px 10px 92px; }
  .builder-shell--with-fab { padding-bottom: 124px; }
  .local-notice { bottom: max(10px, env(safe-area-inset-bottom)); }
  .create-screen { min-height: calc(100vh - 172px); padding-top: 8px; }
  .create-card { padding: 14px; border-radius: 16px; }
  .create-card h1 { font-size: 28px; }
  .create-preview { grid-template-columns: 1fr; }
  .summary-panel { grid-template-columns: 1fr; }
  .side-list { grid-template-columns: 1fr; }
  .side-row-motion-leave-active { width: 100%; }
  .builder-form-row { grid-template-columns: 1fr; }
  .ceiling-preview { max-height: 250px; }
  .preview-panel--expanded .ceiling-preview { max-height: calc(100vh - 150px); }
  .create-fab {
    right: max(10px, env(safe-area-inset-right));
    min-width: 132px;
    min-height: 46px;
    padding: 0 14px;
  }

  .builder-page--with-local-notice .create-fab {
    bottom: max(72px, calc(env(safe-area-inset-bottom) + 72px));
  }
}
</style>
