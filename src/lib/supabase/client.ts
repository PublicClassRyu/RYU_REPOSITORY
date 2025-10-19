import { createBrowserClient } from "@supabase/ssr";
import { environment } from "@/config/environment";
export function createClient() {
  const { SUPABASE_URL, SUPABASE_ANON_KEY } = environment;
  return createBrowserClient(SUPABASE_URL!, SUPABASE_ANON_KEY!);
}
