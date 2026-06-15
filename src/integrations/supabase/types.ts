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
      activity_logs: {
        Row: {
          action: string
          created_at: string
          details: string | null
          id: string
          section: string | null
          user_id: string | null
          username: string | null
        }
        Insert: {
          action: string
          created_at?: string
          details?: string | null
          id?: string
          section?: string | null
          user_id?: string | null
          username?: string | null
        }
        Update: {
          action?: string
          created_at?: string
          details?: string | null
          id?: string
          section?: string | null
          user_id?: string | null
          username?: string | null
        }
        Relationships: []
      }
      admin_user_permissions: {
        Row: {
          created_at: string
          id: string
          permission: string
          permission_type: string
          user_id: string
        }
        Insert: {
          created_at?: string
          id?: string
          permission: string
          permission_type?: string
          user_id: string
        }
        Update: {
          created_at?: string
          id?: string
          permission?: string
          permission_type?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "admin_user_permissions_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "admin_users"
            referencedColumns: ["id"]
          },
        ]
      }
      admin_users: {
        Row: {
          created_at: string
          id: string
          is_active: boolean
          password: string
          updated_at: string
          username: string
        }
        Insert: {
          created_at?: string
          id?: string
          is_active?: boolean
          password: string
          updated_at?: string
          username: string
        }
        Update: {
          created_at?: string
          id?: string
          is_active?: boolean
          password?: string
          updated_at?: string
          username?: string
        }
        Relationships: []
      }
      agent_daily_closings: {
        Row: {
          agent_id: string | null
          balance: number | null
          closed_by: string | null
          closed_by_username: string | null
          closing_date: string
          created_at: string
          delivery_agent_id: string | null
          id: string
          net_amount: number | null
          notes: string | null
          total_collected: number | null
          total_paid: number | null
        }
        Insert: {
          agent_id?: string | null
          balance?: number | null
          closed_by?: string | null
          closed_by_username?: string | null
          closing_date?: string
          created_at?: string
          delivery_agent_id?: string | null
          id?: string
          net_amount?: number | null
          notes?: string | null
          total_collected?: number | null
          total_paid?: number | null
        }
        Update: {
          agent_id?: string | null
          balance?: number | null
          closed_by?: string | null
          closed_by_username?: string | null
          closing_date?: string
          created_at?: string
          delivery_agent_id?: string | null
          id?: string
          net_amount?: number | null
          notes?: string | null
          total_collected?: number | null
          total_paid?: number | null
        }
        Relationships: [
          {
            foreignKeyName: "agent_daily_closings_agent_id_fkey"
            columns: ["agent_id"]
            isOneToOne: false
            referencedRelation: "delivery_agents"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "agent_daily_closings_delivery_agent_id_fkey"
            columns: ["delivery_agent_id"]
            isOneToOne: false
            referencedRelation: "delivery_agents"
            referencedColumns: ["id"]
          },
        ]
      }
      agent_payments: {
        Row: {
          agent_id: string | null
          agent_shipping_cost: number | null
          amount: number
          created_at: string
          delivery_agent_id: string | null
          id: string
          notes: string | null
          order_id: string | null
          payment_date: string | null
          payment_type: string | null
          status: string | null
          type: string
          user_id: string | null
          username: string | null
        }
        Insert: {
          agent_id?: string | null
          agent_shipping_cost?: number | null
          amount?: number
          created_at?: string
          delivery_agent_id?: string | null
          id?: string
          notes?: string | null
          order_id?: string | null
          payment_date?: string | null
          payment_type?: string | null
          status?: string | null
          type?: string
          user_id?: string | null
          username?: string | null
        }
        Update: {
          agent_id?: string | null
          agent_shipping_cost?: number | null
          amount?: number
          created_at?: string
          delivery_agent_id?: string | null
          id?: string
          notes?: string | null
          order_id?: string | null
          payment_date?: string | null
          payment_type?: string | null
          status?: string | null
          type?: string
          user_id?: string | null
          username?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "agent_payments_agent_id_fkey"
            columns: ["agent_id"]
            isOneToOne: false
            referencedRelation: "delivery_agents"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "agent_payments_delivery_agent_id_fkey"
            columns: ["delivery_agent_id"]
            isOneToOne: false
            referencedRelation: "delivery_agents"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "agent_payments_order_id_fkey"
            columns: ["order_id"]
            isOneToOne: false
            referencedRelation: "orders"
            referencedColumns: ["id"]
          },
        ]
      }
      analytics_events: {
        Row: {
          created_at: string
          data: Json | null
          event_type: string
          id: string
          product_id: string | null
          quantity: number | null
        }
        Insert: {
          created_at?: string
          data?: Json | null
          event_type: string
          id?: string
          product_id?: string | null
          quantity?: number | null
        }
        Update: {
          created_at?: string
          data?: Json | null
          event_type?: string
          id?: string
          product_id?: string | null
          quantity?: number | null
        }
        Relationships: []
      }
      app_settings: {
        Row: {
          active_template: string | null
          active_theme: string | null
          created_at: string
          id: string
          invoice_name: string | null
          logo_url: string | null
          platform_name: string
          updated_at: string
          watermark_name: string | null
        }
        Insert: {
          active_template?: string | null
          active_theme?: string | null
          created_at?: string
          id?: string
          invoice_name?: string | null
          logo_url?: string | null
          platform_name?: string
          updated_at?: string
          watermark_name?: string | null
        }
        Update: {
          active_template?: string | null
          active_theme?: string | null
          created_at?: string
          id?: string
          invoice_name?: string | null
          logo_url?: string | null
          platform_name?: string
          updated_at?: string
          watermark_name?: string | null
        }
        Relationships: []
      }
      cashbox: {
        Row: {
          cashbox_date: string | null
          created_at: string
          created_by: string | null
          id: string
          is_active: boolean
          name: string
          opening_balance: number
          updated_at: string
        }
        Insert: {
          cashbox_date?: string | null
          created_at?: string
          created_by?: string | null
          id?: string
          is_active?: boolean
          name: string
          opening_balance?: number
          updated_at?: string
        }
        Update: {
          cashbox_date?: string | null
          created_at?: string
          created_by?: string | null
          id?: string
          is_active?: boolean
          name?: string
          opening_balance?: number
          updated_at?: string
        }
        Relationships: []
      }
      cashbox_transactions: {
        Row: {
          amount: number
          cashbox_id: string | null
          created_at: string
          created_by: string | null
          description: string | null
          id: string
          payment_method: string
          reason: string | null
          reference_id: string | null
          reference_type: string | null
          type: string
          user_id: string | null
          username: string | null
        }
        Insert: {
          amount?: number
          cashbox_id?: string | null
          created_at?: string
          created_by?: string | null
          description?: string | null
          id?: string
          payment_method?: string
          reason?: string | null
          reference_id?: string | null
          reference_type?: string | null
          type?: string
          user_id?: string | null
          username?: string | null
        }
        Update: {
          amount?: number
          cashbox_id?: string | null
          created_at?: string
          created_by?: string | null
          description?: string | null
          id?: string
          payment_method?: string
          reason?: string | null
          reference_id?: string | null
          reference_type?: string | null
          type?: string
          user_id?: string | null
          username?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "cashbox_transactions_cashbox_id_fkey"
            columns: ["cashbox_id"]
            isOneToOne: false
            referencedRelation: "cashbox"
            referencedColumns: ["id"]
          },
        ]
      }
      categories: {
        Row: {
          created_at: string
          description: string | null
          display_order: number | null
          id: string
          image_url: string | null
          is_active: boolean
          name: string
          updated_at: string
        }
        Insert: {
          created_at?: string
          description?: string | null
          display_order?: number | null
          id?: string
          image_url?: string | null
          is_active?: boolean
          name: string
          updated_at?: string
        }
        Update: {
          created_at?: string
          description?: string | null
          display_order?: number | null
          id?: string
          image_url?: string | null
          is_active?: boolean
          name?: string
          updated_at?: string
        }
        Relationships: []
      }
      customers: {
        Row: {
          address: string | null
          created_at: string
          governorate: string | null
          governorate_id: string | null
          id: string
          name: string
          notes: string | null
          phone: string
          phone2: string | null
          updated_at: string
        }
        Insert: {
          address?: string | null
          created_at?: string
          governorate?: string | null
          governorate_id?: string | null
          id?: string
          name: string
          notes?: string | null
          phone: string
          phone2?: string | null
          updated_at?: string
        }
        Update: {
          address?: string | null
          created_at?: string
          governorate?: string | null
          governorate_id?: string | null
          id?: string
          name?: string
          notes?: string | null
          phone?: string
          phone2?: string | null
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "customers_governorate_id_fkey"
            columns: ["governorate_id"]
            isOneToOne: false
            referencedRelation: "governorates"
            referencedColumns: ["id"]
          },
        ]
      }
      delivery_agents: {
        Row: {
          created_at: string
          id: string
          is_active: boolean
          name: string
          phone: string | null
          serial_number: string | null
          total_owed: number | null
          total_paid: number | null
          updated_at: string
        }
        Insert: {
          created_at?: string
          id?: string
          is_active?: boolean
          name: string
          phone?: string | null
          serial_number?: string | null
          total_owed?: number | null
          total_paid?: number | null
          updated_at?: string
        }
        Update: {
          created_at?: string
          id?: string
          is_active?: boolean
          name?: string
          phone?: string | null
          serial_number?: string | null
          total_owed?: number | null
          total_paid?: number | null
          updated_at?: string
        }
        Relationships: []
      }
      governorates: {
        Row: {
          agent_shipping_cost: number
          created_at: string
          display_order: number | null
          id: string
          is_active: boolean
          name: string
          shipping_cost: number
          updated_at: string
        }
        Insert: {
          agent_shipping_cost?: number
          created_at?: string
          display_order?: number | null
          id?: string
          is_active?: boolean
          name: string
          shipping_cost?: number
          updated_at?: string
        }
        Update: {
          agent_shipping_cost?: number
          created_at?: string
          display_order?: number | null
          id?: string
          is_active?: boolean
          name?: string
          shipping_cost?: number
          updated_at?: string
        }
        Relationships: []
      }
      offices: {
        Row: {
          address: string | null
          created_at: string
          id: string
          is_active: boolean
          is_default: boolean
          logo_url: string | null
          name: string
          phone: string | null
          updated_at: string
          watermark_name: string | null
          watermark_url: string | null
        }
        Insert: {
          address?: string | null
          created_at?: string
          id?: string
          is_active?: boolean
          is_default?: boolean
          logo_url?: string | null
          name: string
          phone?: string | null
          updated_at?: string
          watermark_name?: string | null
          watermark_url?: string | null
        }
        Update: {
          address?: string | null
          created_at?: string
          id?: string
          is_active?: boolean
          is_default?: boolean
          logo_url?: string | null
          name?: string
          phone?: string | null
          updated_at?: string
          watermark_name?: string | null
          watermark_url?: string | null
        }
        Relationships: []
      }
      order_items: {
        Row: {
          color: string | null
          created_at: string
          id: string
          image_url: string | null
          order_id: string
          price: number
          product_details: string | null
          product_id: string | null
          product_name: string | null
          quantity: number
          size: string | null
          variant_id: string | null
        }
        Insert: {
          color?: string | null
          created_at?: string
          id?: string
          image_url?: string | null
          order_id: string
          price?: number
          product_details?: string | null
          product_id?: string | null
          product_name?: string | null
          quantity?: number
          size?: string | null
          variant_id?: string | null
        }
        Update: {
          color?: string | null
          created_at?: string
          id?: string
          image_url?: string | null
          order_id?: string
          price?: number
          product_details?: string | null
          product_id?: string | null
          product_name?: string | null
          quantity?: number
          size?: string | null
          variant_id?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "order_items_order_id_fkey"
            columns: ["order_id"]
            isOneToOne: false
            referencedRelation: "orders"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "order_items_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "products"
            referencedColumns: ["id"]
          },
        ]
      }
      orders: {
        Row: {
          agent_deleted: boolean
          agent_shipping_cost: number
          assigned_at: string | null
          barcode_value: string | null
          created_at: string
          customer_address: string | null
          customer_governorate: string | null
          customer_id: string | null
          customer_name: string | null
          customer_phone: string | null
          customer_phone2: string | null
          delivery_agent_id: string | null
          discount: number | null
          governorate_id: string | null
          id: string
          modified_amount: number | null
          notes: string | null
          office_id: string | null
          order_details: string | null
          order_number: string | null
          payment_date: string | null
          payment_method: string | null
          qr_value: string | null
          shipping_cost: number
          status: string
          subtotal: number
          total: number
          total_amount: number
          tracking_code: string | null
          updated_at: string
        }
        Insert: {
          agent_deleted?: boolean
          agent_shipping_cost?: number
          assigned_at?: string | null
          barcode_value?: string | null
          created_at?: string
          customer_address?: string | null
          customer_governorate?: string | null
          customer_id?: string | null
          customer_name?: string | null
          customer_phone?: string | null
          customer_phone2?: string | null
          delivery_agent_id?: string | null
          discount?: number | null
          governorate_id?: string | null
          id?: string
          modified_amount?: number | null
          notes?: string | null
          office_id?: string | null
          order_details?: string | null
          order_number?: string | null
          payment_date?: string | null
          payment_method?: string | null
          qr_value?: string | null
          shipping_cost?: number
          status?: string
          subtotal?: number
          total?: number
          total_amount?: number
          tracking_code?: string | null
          updated_at?: string
        }
        Update: {
          agent_deleted?: boolean
          agent_shipping_cost?: number
          assigned_at?: string | null
          barcode_value?: string | null
          created_at?: string
          customer_address?: string | null
          customer_governorate?: string | null
          customer_id?: string | null
          customer_name?: string | null
          customer_phone?: string | null
          customer_phone2?: string | null
          delivery_agent_id?: string | null
          discount?: number | null
          governorate_id?: string | null
          id?: string
          modified_amount?: number | null
          notes?: string | null
          office_id?: string | null
          order_details?: string | null
          order_number?: string | null
          payment_date?: string | null
          payment_method?: string | null
          qr_value?: string | null
          shipping_cost?: number
          status?: string
          subtotal?: number
          total?: number
          total_amount?: number
          tracking_code?: string | null
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "orders_customer_id_fkey"
            columns: ["customer_id"]
            isOneToOne: false
            referencedRelation: "customers"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "orders_delivery_agent_id_fkey"
            columns: ["delivery_agent_id"]
            isOneToOne: false
            referencedRelation: "delivery_agents"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "orders_governorate_id_fkey"
            columns: ["governorate_id"]
            isOneToOne: false
            referencedRelation: "governorates"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "orders_office_id_fkey"
            columns: ["office_id"]
            isOneToOne: false
            referencedRelation: "offices"
            referencedColumns: ["id"]
          },
        ]
      }
      product_color_variants: {
        Row: {
          color: string
          color_hex: string | null
          created_at: string
          id: string
          image_url: string | null
          product_id: string
          stock: number | null
        }
        Insert: {
          color: string
          color_hex?: string | null
          created_at?: string
          id?: string
          image_url?: string | null
          product_id: string
          stock?: number | null
        }
        Update: {
          color?: string
          color_hex?: string | null
          created_at?: string
          id?: string
          image_url?: string | null
          product_id?: string
          stock?: number | null
        }
        Relationships: [
          {
            foreignKeyName: "product_color_variants_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "products"
            referencedColumns: ["id"]
          },
        ]
      }
      product_images: {
        Row: {
          created_at: string
          display_order: number | null
          id: string
          image_url: string
          product_id: string
        }
        Insert: {
          created_at?: string
          display_order?: number | null
          id?: string
          image_url: string
          product_id: string
        }
        Update: {
          created_at?: string
          display_order?: number | null
          id?: string
          image_url?: string
          product_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "product_images_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "products"
            referencedColumns: ["id"]
          },
        ]
      }
      products: {
        Row: {
          category_id: string | null
          color_options: Json | null
          created_at: string
          description: string | null
          details: string | null
          id: string
          image_url: string | null
          is_active: boolean
          is_offer: boolean
          name: string
          offer_price: number | null
          price: number
          price_10: number | null
          price_11: number | null
          price_12: number | null
          price_2: number | null
          price_3: number | null
          price_4: number | null
          price_5: number | null
          price_6: number | null
          price_7: number | null
          price_8: number | null
          price_9: number | null
          quantity_pricing: Json | null
          size_options: Json | null
          stock: number
          updated_at: string
        }
        Insert: {
          category_id?: string | null
          color_options?: Json | null
          created_at?: string
          description?: string | null
          details?: string | null
          id?: string
          image_url?: string | null
          is_active?: boolean
          is_offer?: boolean
          name: string
          offer_price?: number | null
          price?: number
          price_10?: number | null
          price_11?: number | null
          price_12?: number | null
          price_2?: number | null
          price_3?: number | null
          price_4?: number | null
          price_5?: number | null
          price_6?: number | null
          price_7?: number | null
          price_8?: number | null
          price_9?: number | null
          quantity_pricing?: Json | null
          size_options?: Json | null
          stock?: number
          updated_at?: string
        }
        Update: {
          category_id?: string | null
          color_options?: Json | null
          created_at?: string
          description?: string | null
          details?: string | null
          id?: string
          image_url?: string | null
          is_active?: boolean
          is_offer?: boolean
          name?: string
          offer_price?: number | null
          price?: number
          price_10?: number | null
          price_11?: number | null
          price_12?: number | null
          price_2?: number | null
          price_3?: number | null
          price_4?: number | null
          price_5?: number | null
          price_6?: number | null
          price_7?: number | null
          price_8?: number | null
          price_9?: number | null
          quantity_pricing?: Json | null
          size_options?: Json | null
          stock?: number
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "products_category_id_fkey"
            columns: ["category_id"]
            isOneToOne: false
            referencedRelation: "categories"
            referencedColumns: ["id"]
          },
        ]
      }
      returns: {
        Row: {
          agent_id: string | null
          amount: number | null
          created_at: string
          customer_id: string | null
          delivery_agent_id: string | null
          id: string
          notes: string | null
          order_id: string
          reason: string | null
          return_amount: number | null
          returned_at: string
          returned_items: Json | null
        }
        Insert: {
          agent_id?: string | null
          amount?: number | null
          created_at?: string
          customer_id?: string | null
          delivery_agent_id?: string | null
          id?: string
          notes?: string | null
          order_id: string
          reason?: string | null
          return_amount?: number | null
          returned_at?: string
          returned_items?: Json | null
        }
        Update: {
          agent_id?: string | null
          amount?: number | null
          created_at?: string
          customer_id?: string | null
          delivery_agent_id?: string | null
          id?: string
          notes?: string | null
          order_id?: string
          reason?: string | null
          return_amount?: number | null
          returned_at?: string
          returned_items?: Json | null
        }
        Relationships: [
          {
            foreignKeyName: "returns_agent_id_fkey"
            columns: ["agent_id"]
            isOneToOne: false
            referencedRelation: "delivery_agents"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "returns_customer_id_fkey"
            columns: ["customer_id"]
            isOneToOne: false
            referencedRelation: "customers"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "returns_delivery_agent_id_fkey"
            columns: ["delivery_agent_id"]
            isOneToOne: false
            referencedRelation: "delivery_agents"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "returns_order_id_fkey"
            columns: ["order_id"]
            isOneToOne: false
            referencedRelation: "orders"
            referencedColumns: ["id"]
          },
        ]
      }
      scan_logs: {
        Row: {
          action: string | null
          barcode_value: string | null
          created_at: string
          id: string
          new_value: string | null
          order_id: string | null
          result: string | null
          scanned_at: string
          session_id: string | null
          user_id: string | null
          username: string | null
        }
        Insert: {
          action?: string | null
          barcode_value?: string | null
          created_at?: string
          id?: string
          new_value?: string | null
          order_id?: string | null
          result?: string | null
          scanned_at?: string
          session_id?: string | null
          user_id?: string | null
          username?: string | null
        }
        Update: {
          action?: string | null
          barcode_value?: string | null
          created_at?: string
          id?: string
          new_value?: string | null
          order_id?: string | null
          result?: string | null
          scanned_at?: string
          session_id?: string | null
          user_id?: string | null
          username?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "scan_logs_order_id_fkey"
            columns: ["order_id"]
            isOneToOne: false
            referencedRelation: "orders"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "scan_logs_session_id_fkey"
            columns: ["session_id"]
            isOneToOne: false
            referencedRelation: "scan_sessions"
            referencedColumns: ["id"]
          },
        ]
      }
      scan_session_items: {
        Row: {
          barcode_value: string | null
          id: string
          order_id: string | null
          scanned_at: string
          session_id: string
        }
        Insert: {
          barcode_value?: string | null
          id?: string
          order_id?: string | null
          scanned_at?: string
          session_id: string
        }
        Update: {
          barcode_value?: string | null
          id?: string
          order_id?: string | null
          scanned_at?: string
          session_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "scan_session_items_order_id_fkey"
            columns: ["order_id"]
            isOneToOne: false
            referencedRelation: "orders"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "scan_session_items_session_id_fkey"
            columns: ["session_id"]
            isOneToOne: false
            referencedRelation: "scan_sessions"
            referencedColumns: ["id"]
          },
        ]
      }
      scan_sessions: {
        Row: {
          created_at: string
          created_by: string | null
          ended_at: string | null
          id: string
          session_name: string | null
          status: string | null
          total_scanned: number | null
          updated_at: string
          user_id: string | null
          username: string | null
        }
        Insert: {
          created_at?: string
          created_by?: string | null
          ended_at?: string | null
          id?: string
          session_name?: string | null
          status?: string | null
          total_scanned?: number | null
          updated_at?: string
          user_id?: string | null
          username?: string | null
        }
        Update: {
          created_at?: string
          created_by?: string | null
          ended_at?: string | null
          id?: string
          session_name?: string | null
          status?: string | null
          total_scanned?: number | null
          updated_at?: string
          user_id?: string | null
          username?: string | null
        }
        Relationships: []
      }
      statistics: {
        Row: {
          created_at: string
          data: Json | null
          id: string
          last_reset: string | null
          metric: string | null
          period: string | null
          total_orders: number | null
          total_sales: number | null
          value: number | null
        }
        Insert: {
          created_at?: string
          data?: Json | null
          id?: string
          last_reset?: string | null
          metric?: string | null
          period?: string | null
          total_orders?: number | null
          total_sales?: number | null
          value?: number | null
        }
        Update: {
          created_at?: string
          data?: Json | null
          id?: string
          last_reset?: string | null
          metric?: string | null
          period?: string | null
          total_orders?: number | null
          total_sales?: number | null
          value?: number | null
        }
        Relationships: []
      }
      system_passwords: {
        Row: {
          id: string
          key: string
          password: string
          updated_at: string
        }
        Insert: {
          id?: string
          key: string
          password: string
          updated_at?: string
        }
        Update: {
          id?: string
          key?: string
          password?: string
          updated_at?: string
        }
        Relationships: []
      }
      treasury: {
        Row: {
          amount: number | null
          balance: number
          category: string | null
          created_at: string
          created_by: string | null
          description: string | null
          id: string
          last_updated: string
          name: string
          office_id: string | null
          type: string | null
          updated_at: string
          user_id: string | null
          username: string | null
        }
        Insert: {
          amount?: number | null
          balance?: number
          category?: string | null
          created_at?: string
          created_by?: string | null
          description?: string | null
          id?: string
          last_updated?: string
          name?: string
          office_id?: string | null
          type?: string | null
          updated_at?: string
          user_id?: string | null
          username?: string | null
        }
        Update: {
          amount?: number | null
          balance?: number
          category?: string | null
          created_at?: string
          created_by?: string | null
          description?: string | null
          id?: string
          last_updated?: string
          name?: string
          office_id?: string | null
          type?: string | null
          updated_at?: string
          user_id?: string | null
          username?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "treasury_office_id_fkey"
            columns: ["office_id"]
            isOneToOne: false
            referencedRelation: "offices"
            referencedColumns: ["id"]
          },
        ]
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      delete_old_activity_logs: { Args: never; Returns: number }
      reset_order_sequence: { Args: never; Returns: undefined }
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
