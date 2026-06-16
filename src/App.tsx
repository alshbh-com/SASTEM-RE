import { Suspense, lazy } from "react";
import { Toaster } from "@/components/ui/toaster";
import { Toaster as Sonner } from "@/components/ui/sonner";
import { TooltipProvider } from "@/components/ui/tooltip";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { BrowserRouter, Routes, Route } from "react-router-dom";
import { AdminAuthProvider } from "@/contexts/AdminAuthContext";
import { ThemeProvider } from "@/contexts/ThemeContext";
import ProtectedAdminRoute from "@/components/ProtectedAdminRoute";
import Home from "./pages/Home";
import BottomNav from "./components/BottomNav";
import TopNav from "./components/TopNav";
import NotFound from "./pages/NotFound";

// Lazy-load heavy/secondary routes to speed up first load
const Cart = lazy(() => import("./pages/Cart"));
const Settings = lazy(() => import("./pages/Settings"));
const Dashboard = lazy(() => import("./pages/admin/Dashboard"));
const Customers = lazy(() => import("./pages/admin/Customers"));
const Agents = lazy(() => import("./pages/admin/Agents"));
const Orders = lazy(() => import("./pages/admin/Orders"));
const Products = lazy(() => import("./pages/admin/Products"));
const Categories = lazy(() => import("./pages/admin/Categories"));
const AgentOrders = lazy(() => import("./pages/admin/AgentOrders"));
const Statistics = lazy(() => import("./pages/admin/Statistics"));
const Invoices = lazy(() => import("./pages/admin/Invoices"));
const Governorates = lazy(() => import("./pages/admin/Governorates"));
const AllOrders = lazy(() => import("./pages/admin/AllOrders"));
const ResetData = lazy(() => import("./pages/admin/ResetData"));
const UserManagement = lazy(() => import("./pages/admin/UserManagement"));
const ActivityLogs = lazy(() => import("./pages/admin/ActivityLogs"));
const Treasury = lazy(() => import("./pages/admin/Treasury"));
const Cashbox = lazy(() => import("./pages/admin/Cashbox"));
const Appearance = lazy(() => import("./pages/admin/Appearance"));
const Offices = lazy(() => import("./pages/admin/Offices"));
const BarcodeScanner = lazy(() => import("./pages/admin/BarcodeScanner"));

const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 60_000, // 1 minute - reduce redundant refetches
      gcTime: 5 * 60_000,
      refetchOnWindowFocus: false,
      retry: 1,
    },
  },
});

const AdminRoute = ({ children }: { children: React.ReactNode }) => (
  <ProtectedAdminRoute>{children}</ProtectedAdminRoute>
);

const PageFallback = () => (
  <div className="flex items-center justify-center min-h-[50vh] text-muted-foreground">
    جاري التحميل...
  </div>
);

const App = () => (
  <QueryClientProvider client={queryClient}>
    <TooltipProvider>
      <AdminAuthProvider>
        <ThemeProvider>
          <Toaster />
          <Sonner />
          <BrowserRouter>
            <TopNav />
            <div className="pb-16 pt-16">
              <Suspense fallback={<PageFallback />}>
                <Routes>
                  <Route path="/" element={<Home />} />
                  <Route path="/cart" element={<Cart />} />
                  <Route path="/settings" element={<Settings />} />
                  <Route path="/admin" element={<AdminRoute><Dashboard /></AdminRoute>} />
                  <Route path="/admin/customers" element={<AdminRoute><Customers /></AdminRoute>} />
                  <Route path="/admin/agents" element={<AdminRoute><Agents /></AdminRoute>} />
                  <Route path="/admin/orders" element={<AdminRoute><Orders /></AdminRoute>} />
                  <Route path="/admin/products" element={<AdminRoute><Products /></AdminRoute>} />
                  <Route path="/admin/categories" element={<AdminRoute><Categories /></AdminRoute>} />
                  <Route path="/admin/agent-orders" element={<AdminRoute><AgentOrders /></AdminRoute>} />
                  <Route path="/admin/statistics" element={<AdminRoute><Statistics /></AdminRoute>} />
                  <Route path="/admin/invoices" element={<AdminRoute><Invoices /></AdminRoute>} />
                  <Route path="/admin/governorates" element={<AdminRoute><Governorates /></AdminRoute>} />
                  <Route path="/admin/all-orders" element={<AdminRoute><AllOrders /></AdminRoute>} />
                  <Route path="/admin/reset-data" element={<AdminRoute><ResetData /></AdminRoute>} />
                  <Route path="/admin/users" element={<AdminRoute><UserManagement /></AdminRoute>} />
                  <Route path="/admin/activity" element={<AdminRoute><ActivityLogs /></AdminRoute>} />
                  <Route path="/admin/treasury" element={<AdminRoute><Treasury /></AdminRoute>} />
                  <Route path="/admin/cashbox" element={<AdminRoute><Cashbox /></AdminRoute>} />
                  <Route path="/admin/appearance" element={<AdminRoute><Appearance /></AdminRoute>} />
                  <Route path="/admin/offices" element={<AdminRoute><Offices /></AdminRoute>} />
                  <Route path="/admin/barcode-scanner" element={<AdminRoute><BarcodeScanner /></AdminRoute>} />
                  <Route path="*" element={<NotFound />} />
                </Routes>
              </Suspense>
              <BottomNav />
            </div>
          </BrowserRouter>
        </ThemeProvider>
      </AdminAuthProvider>
    </TooltipProvider>
  </QueryClientProvider>
);

export default App;
