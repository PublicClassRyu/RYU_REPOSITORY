import z from "zod";

export const loginSchemaForm = z.object({
  email: z
    .string()
    .min(1, "Email wajib di isi")
    .email("Tolong isi email dengan benar"),

  password: z.string().min(1, "Paswword wajib di isi"),
});

export type LoginForm = z.infer<typeof loginSchemaForm>;
