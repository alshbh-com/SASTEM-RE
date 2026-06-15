// رفع الصور على imgBB والحصول على رابط مباشر
// المفتاح عام (publishable) - آمن في الكود
const IMGBB_API_KEY = "2ab2a8ea4a6e2b1b4f3df5591062ff75";
const IMGBB_ENDPOINT = "https://api.imgbb.com/1/upload";

export interface ImgBBResult {
  url: string;
  display_url: string;
  delete_url: string;
}

/**
 * يرفع ملف صورة على imgBB ويرجع الرابط المباشر
 */
export async function uploadImageToImgBB(file: File): Promise<ImgBBResult> {
  if (!file) throw new Error("لا توجد صورة");
  if (!file.type.startsWith("image/")) throw new Error("الملف ليس صورة");
  if (file.size > 32 * 1024 * 1024) throw new Error("حجم الصورة أكبر من 32MB");

  const formData = new FormData();
  formData.append("image", file);

  const res = await fetch(`${IMGBB_ENDPOINT}?key=${IMGBB_API_KEY}`, {
    method: "POST",
    body: formData,
  });

  if (!res.ok) {
    throw new Error(`فشل رفع الصورة (${res.status})`);
  }

  const json = await res.json();
  if (!json?.data?.url) {
    throw new Error(json?.error?.message || "فشل رفع الصورة");
  }

  return {
    url: json.data.url,
    display_url: json.data.display_url,
    delete_url: json.data.delete_url,
  };
}

/**
 * يرفع عدة صور بالتوازي ويرجع روابطها
 */
export async function uploadMultipleImagesToImgBB(files: File[]): Promise<ImgBBResult[]> {
  return Promise.all(files.map((f) => uploadImageToImgBB(f)));
}
