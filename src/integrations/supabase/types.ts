export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export type Database = {
  // Allows to automatically instantiate createClient with right options
  // instead of createClient<Database, { PostgrestVersion: 'XX' }>(URL, KEY)
  __InternalSupabase: {
    PostgrestVersion: "14.5"
  }
  public: {
    Tables: {
      "activity_logs_rows.csv": {
        Row: {
          action: string | null
          created_at: string | null
          details: string | null
          id: string | null
          section: string | null
          user_id: string | null
          username: string | null
        }
        Insert: {
          action?: string | null
          created_at?: string | null
          details?: string | null
          id?: string | null
          section?: string | null
          user_id?: string | null
          username?: string | null
        }
        Update: {
          action?: string | null
          created_at?: string | null
          details?: string | null
          id?: string | null
          section?: string | null
          user_id?: string | null
          username?: string | null
        }
        Relationships: []
      }
      "admin_user_permissions_rows.csv": {
        Row: {
          created_at: string | null
          id: string | null
          permission: string | null
          permission_type: string | null
          user_id: string | null
        }
        Insert: {
          created_at?: string | null
          id?: string | null
          permission?: string | null
          permission_type?: string | null
          user_id?: string | null
        }
        Update: {
          created_at?: string | null
          id?: string | null
          permission?: string | null
          permission_type?: string | null
          user_id?: string | null
        }
        Relationships: []
      }
      admin_users_rows: {
        Row: {
          created_at: string | null
          id: string | null
          is_active: boolean | null
          password: number | null
          updated_at: string | null
          username: string | null
        }
        Insert: {
          created_at?: string | null
          id?: string | null
          is_active?: boolean | null
          password?: number | null
          updated_at?: string | null
          username?: string | null
        }
        Update: {
          created_at?: string | null
          id?: string | null
          is_active?: boolean | null
          password?: number | null
          updated_at?: string | null
          username?: string | null
        }
        Relationships: []
      }
      "app_settings_rows.csv": {
        Row: {
          active_template: string | null
          active_theme: string | null
          created_at: string | null
          id: string | null
          invoice_name: string | null
          logo_url: string | null
          platform_name: string | null
          updated_at: string | null
          watermark_name: string | null
        }
        Insert: {
          active_template?: string | null
          active_theme?: string | null
          created_at?: string | null
          id?: string | null
          invoice_name?: string | null
          logo_url?: string | null
          platform_name?: string | null
          updated_at?: string | null
          watermark_name?: string | null
        }
        Update: {
          active_template?: string | null
          active_theme?: string | null
          created_at?: string | null
          id?: string | null
          invoice_name?: string | null
          logo_url?: string | null
          platform_name?: string | null
          updated_at?: string | null
          watermark_name?: string | null
        }
        Relationships: []
      }
      "cashbox_rows.csv": {
        Row: {
          created_at: string | null
          created_by: string | null
          id: string | null
          is_active: boolean | null
          name: string | null
          opening_balance: number | null
          updated_at: string | null
        }
        Insert: {
          created_at?: string | null
          created_by?: string | null
          id?: string | null
          is_active?: boolean | null
          name?: string | null
          opening_balance?: number | null
          updated_at?: string | null
        }
        Update: {
          created_at?: string | null
          created_by?: string | null
          id?: string | null
          is_active?: boolean | null
          name?: string | null
          opening_balance?: number | null
          updated_at?: string | null
        }
        Relationships: []
      }
      "categories_rows.csv": {
        Row: {
          created_at: string | null
          description: string | null
          display_order: number | null
          id: string | null
          image_url: string | null
          is_active: boolean | null
          name: string | null
          updated_at: string | null
        }
        Insert: {
          created_at?: string | null
          description?: string | null
          display_order?: number | null
          id?: string | null
          image_url?: string | null
          is_active?: boolean | null
          name?: string | null
          updated_at?: string | null
        }
        Update: {
          created_at?: string | null
          description?: string | null
          display_order?: number | null
          id?: string | null
          image_url?: string | null
          is_active?: boolean | null
          name?: string | null
          updated_at?: string | null
        }
        Relationships: []
      }
      "customers_rows.csv": {
        Row: {
          address: string | null
          created_at: string | null
          governorate: string | null
          governorate_id: string | null
          id: string | null
          name: string | null
          notes: string | null
          phone: number | null
          phone2: string | null
          updated_at: string | null
        }
        Insert: {
          address?: string | null
          created_at?: string | null
          governorate?: string | null
          governorate_id?: string | null
          id?: string | null
          name?: string | null
          notes?: string | null
          phone?: number | null
          phone2?: string | null
          updated_at?: string | null
        }
        Update: {
          address?: string | null
          created_at?: string | null
          governorate?: string | null
          governorate_id?: string | null
          id?: string | null
          name?: string | null
          notes?: string | null
          phone?: number | null
          phone2?: string | null
          updated_at?: string | null
        }
        Relationships: []
      }
      "governorates_rows.csv": {
        Row: {
          agent_shipping_cost: number | null
          created_at: string | null
          id: string | null
          name: string | null
          shipping_cost: number | null
          updated_at: string | null
        }
        Insert: {
          agent_shipping_cost?: number | null
          created_at?: string | null
          id?: string | null
          name?: string | null
          shipping_cost?: number | null
          updated_at?: string | null
        }
        Update: {
          agent_shipping_cost?: number | null
          created_at?: string | null
          id?: string | null
          name?: string | null
          shipping_cost?: number | null
          updated_at?: string | null
        }
        Relationships: []
      }
      "meta_settings_rows.csv": {
        Row: {
          access_token: string | null
          id: string | null
          pixel_id: number | null
          test_event_code: string | null
          updated_at: string | null
        }
        Insert: {
          access_token?: string | null
          id?: string | null
          pixel_id?: number | null
          test_event_code?: string | null
          updated_at?: string | null
        }
        Update: {
          access_token?: string | null
          id?: string | null
          pixel_id?: number | null
          test_event_code?: string | null
          updated_at?: string | null
        }
        Relationships: []
      }
      "order_items_rows.csv": {
        Row: {
          color: string | null
          created_at: string | null
          id: string | null
          order_id: string | null
          price: number | null
          product_details: string | null
          product_id: string | null
          quantity: number | null
          size: string | null
        }
        Insert: {
          color?: string | null
          created_at?: string | null
          id?: string | null
          order_id?: string | null
          price?: number | null
          product_details?: string | null
          product_id?: string | null
          quantity?: number | null
          size?: string | null
        }
        Update: {
          color?: string | null
          created_at?: string | null
          id?: string | null
          order_id?: string | null
          price?: number | null
          product_details?: string | null
          product_id?: string | null
          quantity?: number | null
          size?: string | null
        }
        Relationships: []
      }
      "orders_rows.csv": {
        Row: {
          agent_shipping_cost: number | null
          assigned_at: string | null
          barcode_value: string | null
          created_at: string | null
          customer_id: string | null
          delivery_agent_id: string | null
          discount: number | null
          governorate_id: string | null
          id: string | null
          modified_amount: number | null
          notes: string | null
          office_id: string | null
          order_details: string | null
          order_number: number | null
          payment_date: string | null
          qr_value: string | null
          shipping_cost: number | null
          status: string | null
          total_amount: number | null
          tracking_code: string | null
          updated_at: string | null
        }
        Insert: {
          agent_shipping_cost?: number | null
          assigned_at?: string | null
          barcode_value?: string | null
          created_at?: string | null
          customer_id?: string | null
          delivery_agent_id?: string | null
          discount?: number | null
          governorate_id?: string | null
          id?: string | null
          modified_amount?: number | null
          notes?: string | null
          office_id?: string | null
          order_details?: string | null
          order_number?: number | null
          payment_date?: string | null
          qr_value?: string | null
          shipping_cost?: number | null
          status?: string | null
          total_amount?: number | null
          tracking_code?: string | null
          updated_at?: string | null
        }
        Update: {
          agent_shipping_cost?: number | null
          assigned_at?: string | null
          barcode_value?: string | null
          created_at?: string | null
          customer_id?: string | null
          delivery_agent_id?: string | null
          discount?: number | null
          governorate_id?: string | null
          id?: string | null
          modified_amount?: number | null
          notes?: string | null
          office_id?: string | null
          order_details?: string | null
          order_number?: number | null
          payment_date?: string | null
          qr_value?: string | null
          shipping_cost?: number | null
          status?: string | null
          total_amount?: number | null
          tracking_code?: string | null
          updated_at?: string | null
        }
        Relationships: []
      }
      "products_rows.csv": {
        Row: {
          category_id: string | null
          color_options: string | null
          created_at: string | null
          description: string | null
          details: string | null
          id: string | null
          image_url: string | null
          is_active: boolean | null
          is_offer: boolean | null
          name: string | null
          offer_price: number | null
          price: number | null
          quantity_pricing: Json | null
          size_options: Json | null
          stock: number | null
          updated_at: string | null
        }
        Insert: {
          category_id?: string | null
          color_options?: string | null
          created_at?: string | null
          description?: string | null
          details?: string | null
          id?: string | null
          image_url?: string | null
          is_active?: boolean | null
          is_offer?: boolean | null
          name?: string | null
          offer_price?: number | null
          price?: number | null
          quantity_pricing?: Json | null
          size_options?: Json | null
          stock?: number | null
          updated_at?: string | null
        }
        Update: {
          category_id?: string | null
          color_options?: string | null
          created_at?: string | null
          description?: string | null
          details?: string | null
          id?: string | null
          image_url?: string | null
          is_active?: boolean | null
          is_offer?: boolean | null
          name?: string | null
          offer_price?: number | null
          price?: number | null
          quantity_pricing?: Json | null
          size_options?: Json | null
          stock?: number | null
          updated_at?: string | null
        }
        Relationships: []
      }
      "scan_sessions_rows.csv": {
        Row: {
          ended_at: string | null
          id: string | null
          started_at: string | null
          status: string | null
          total_scanned: number | null
          user_id: string | null
          username: string | null
        }
        Insert: {
          ended_at?: string | null
          id?: string | null
          started_at?: string | null
          status?: string | null
          total_scanned?: number | null
          user_id?: string | null
          username?: string | null
        }
        Update: {
          ended_at?: string | null
          id?: string | null
          started_at?: string | null
          status?: string | null
          total_scanned?: number | null
          user_id?: string | null
          username?: string | null
        }
        Relationships: []
      }
      "statistics_rows.csv": {
        Row: {
          created_at: string | null
          id: string | null
          last_reset: string | null
          total_orders: number | null
          total_sales: number | null
          updated_at: string | null
        }
        Insert: {
          created_at?: string | null
          id?: string | null
          last_reset?: string | null
          total_orders?: number | null
          total_sales?: number | null
          updated_at?: string | null
        }
        Update: {
          created_at?: string | null
          id?: string | null
          last_reset?: string | null
          total_orders?: number | null
          total_sales?: number | null
          updated_at?: string | null
        }
        Relationships: []
      }
      "system_passwords_rows.csv": {
        Row: {
          id: string | null
          password: number | null
          updated_at: string | null
        }
        Insert: {
          id?: string | null
          password?: number | null
          updated_at?: string | null
        }
        Update: {
          id?: string | null
          password?: number | null
          updated_at?: string | null
        }
        Relationships: []
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      [_ in never]: never
    }
    Enums: {
      [_ in never]: never
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
}

type DatabaseWithoutInternals = Omit<Database, "__InternalSupabase">

type DefaultSchema = DatabaseWithoutInternals[Extract<keyof Database, "public">]

export type Tables<
  DefaultSchemaTableNameOrOptions extends
    | keyof (DefaultSchema["Tables"] & DefaultSchema["Views"])
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
        DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
      DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])[TableName] extends {
      Row: infer R
    }
    ? R
    : never
  : DefaultSchemaTableNameOrOptions extends keyof (DefaultSchema["Tables"] &
        DefaultSchema["Views"])
    ? (DefaultSchema["Tables"] &
        DefaultSchema["Views"])[DefaultSchemaTableNameOrOptions] extends {
        Row: infer R
      }
      ? R
      : never
    : never

export type TablesInsert<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Insert: infer I
    }
    ? I
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Insert: infer I
      }
      ? I
      : never
    : never

export type TablesUpdate<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Update: infer U
    }
    ? U
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Update: infer U
      }
      ? U
      : never
    : never

export type Enums<
  DefaultSchemaEnumNameOrOptions extends
    | keyof DefaultSchema["Enums"]
    | { schema: keyof DatabaseWithoutInternals },
  EnumName extends DefaultSchemaEnumNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"]
    : never = never,
> = DefaultSchemaEnumNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"][EnumName]
  : DefaultSchemaEnumNameOrOptions extends keyof DefaultSchema["Enums"]
    ? DefaultSchema["Enums"][DefaultSchemaEnumNameOrOptions]
    : never

export type CompositeTypes<
  PublicCompositeTypeNameOrOptions extends
    | keyof DefaultSchema["CompositeTypes"]
    | { schema: keyof DatabaseWithoutInternals },
  CompositeTypeName extends PublicCompositeTypeNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"]
    : never = never,
> = PublicCompositeTypeNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"][CompositeTypeName]
  : PublicCompositeTypeNameOrOptions extends keyof DefaultSchema["CompositeTypes"]
    ? DefaultSchema["CompositeTypes"][PublicCompositeTypeNameOrOptions]
    : never

export const Constants = {
  public: {
    Enums: {},
  },
} as const
