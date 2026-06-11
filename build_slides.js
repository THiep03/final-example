const pptxgen = require("pptxgenjs");
const React = require("react");
const ReactDOMServer = require("react-dom/server");
const sharp = require("sharp");
const {
  FaVideo, FaCamera, FaBrain, FaChartLine, FaUserGraduate, FaUserShield,
  FaDatabase, FaReact, FaJava, FaServer, FaEye, FaBolt, FaCheckCircle,
  FaLayerGroup, FaSignInAlt, FaClipboardCheck, FaListOl, FaArrowRight,
  FaGraduationCap, FaLightbulb, FaCogs, FaExclamationTriangle, FaRocket,
  FaListUl, FaBullseye, FaCrosshairs, FaUsers, FaCode, FaShieldAlt,
  FaLock, FaProjectDiagram, FaComments, FaTachometerAlt, FaPlayCircle,
  FaRulerCombined, FaStream, FaKey, FaUpload, FaQuestionCircle, FaPercentage,
} = require("react-icons/fa");

// ---------- Palette (Ed-tech / AI: deep teal + navy) ----------
const DARK = "0B2E33";
const TEAL = "0D9488";
const MINT = "14B8A6";
const LIGHT_MINT = "5EEAD4";
const ACCENT = "F4A259";
const WHITE = "FFFFFF";
const INK = "1E293B";
const MUTED = "64748B";
const CARD = "F1F5F9";
const CARD2 = "E8F3F2";

const HEAD = "Georgia";
const BODY = "Calibri";

async function iconPng(IconComponent, color, size = 256) {
  const svg = ReactDOMServer.renderToStaticMarkup(
    React.createElement(IconComponent, { color, size: String(size) })
  );
  const buf = await sharp(Buffer.from(svg)).png().toBuffer();
  return "image/png;base64," + buf.toString("base64");
}

const pres = new pptxgen();
pres.layout = "LAYOUT_WIDE";
pres.author = "Nhom DATN";
pres.title = "He thong hoc tap truc tuyen voi AI";

const sh = () => ({ type: "outer", color: "0B2E33", blur: 8, offset: 3, angle: 135, opacity: 0.12 });

// ---------- shared helpers (need ic) ----------
let ic = {};
function iconBadge(slide, key, x, y, d = 0.7, circle = TEAL, tone = "white") {
  slide.addShape(pres.shapes.OVAL, { x, y, w: d, h: d, fill: { color: circle }, shadow: sh() });
  const p = d * 0.5;
  slide.addImage({ data: ic[key][tone], x: x + (d - p) / 2, y: y + (d - p) / 2, w: p, h: p });
}
function eyebrow(slide, text, x, y, color = TEAL) {
  slide.addText(text.toUpperCase(), { x, y, w: 8, h: 0.3, fontFace: BODY, fontSize: 12, bold: true, color, charSpacing: 3, margin: 0, align: "left" });
}
function pageTitle(slide, text, x, y, color = INK, w = 11.7) {
  slide.addText(text, { x, y, w, h: 0.9, fontFace: HEAD, fontSize: 31, bold: true, color, margin: 0, align: "left" });
}
function footer(slide, n) {
  slide.addText("Hệ thống học tập trực tuyến với AI", { x: 0.6, y: 7.05, w: 8, h: 0.3, fontFace: BODY, fontSize: 9, color: MUTED, margin: 0 });
  slide.addText(String(n), { x: 12.4, y: 7.05, w: 0.4, h: 0.3, fontFace: BODY, fontSize: 9, color: MUTED, align: "right", margin: 0 });
}
// light content slide scaffold
function lightHead(eb, title, n) {
  const s = pres.addSlide();
  s.background = { color: WHITE };
  eyebrow(s, eb, 0.6, 0.55);
  pageTitle(s, title, 0.6, 0.9);
  footer(s, n);
  return s;
}
function darkHead(eb, title, n) {
  const s = pres.addSlide();
  s.background = { color: DARK };
  eyebrow(s, eb, 0.6, 0.55, LIGHT_MINT);
  pageTitle(s, title, 0.6, 0.9, WHITE);
  footer(s, n);
  return s;
}
// generic 3-card row (light)
function threeCards(s, items, opt = {}) {
  const y = opt.y || 2.15, h = opt.h || 3.8;
  let x = 0.6;
  for (const it of items) {
    s.addShape(pres.shapes.ROUNDED_RECTANGLE, { x, y, w: 3.9, h, fill: { color: opt.fill || CARD }, line: { type: "none" }, rectRadius: 0.12, shadow: sh() });
    iconBadge(s, it.k, x + 0.35, y + 0.32, 0.8, opt.circle || TEAL, "white");
    s.addText(it.t, { x: x + 0.35, y: y + 1.25, w: 3.3, h: 0.6, fontFace: HEAD, fontSize: 17, bold: true, color: INK, margin: 0 });
    s.addText(it.d, { x: x + 0.35, y: y + 1.9, w: 3.3, h: h - 2.0, fontFace: BODY, fontSize: 13, color: MUTED, margin: 0, lineSpacing: 18 });
    x += 4.1;
  }
}
// vertical list rows in a panel
function rowList(s, items, x, y, w, opt = {}) {
  const rh = opt.rh || 1.0;
  items.forEach((it, i) => {
    const yy = y + i * rh;
    s.addShape(pres.shapes.ROUNDED_RECTANGLE, { x, y: yy, w, h: rh - 0.12, fill: { color: i % 2 ? CARD : CARD2 }, line: { type: "none" }, rectRadius: 0.08 });
    iconBadge(s, it.k, x + 0.25, yy + (rh - 0.12) / 2 - 0.3, 0.6, opt.circle || TEAL, "white");
    s.addText(it.t, { x: x + 1.05, y: yy + 0.12, w: w - 1.3, h: 0.4, fontFace: HEAD, fontSize: 14.5, bold: true, color: INK, margin: 0 });
    s.addText(it.d, { x: x + 1.05, y: yy + 0.49, w: w - 1.3, h: 0.35, fontFace: BODY, fontSize: 11.5, color: MUTED, margin: 0 });
  });
}

async function build() {
  const need = {
    FaVideo, FaCamera, FaBrain, FaChartLine, FaUserGraduate, FaUserShield,
    FaDatabase, FaReact, FaJava, FaServer, FaEye, FaBolt, FaCheckCircle,
    FaLayerGroup, FaSignInAlt, FaClipboardCheck, FaListOl, FaArrowRight,
    FaGraduationCap, FaLightbulb, FaCogs, FaExclamationTriangle, FaRocket,
    FaListUl, FaBullseye, FaCrosshairs, FaUsers, FaCode, FaShieldAlt,
    FaLock, FaProjectDiagram, FaComments, FaTachometerAlt, FaPlayCircle,
    FaRulerCombined, FaStream, FaKey, FaUpload, FaQuestionCircle, FaPercentage,
  };
  for (const [k, C] of Object.entries(need)) {
    ic[k] = { white: await iconPng(C, "#FFFFFF"), teal: await iconPng(C, "#0D9488"), dark: await iconPng(C, "#0B2E33"), accent: await iconPng(C, "#F4A259") };
  }

  let n = 0;

  // ===== 1. TITLE =====
  let s = pres.addSlide();
  s.background = { color: DARK };
  s.addShape(pres.shapes.OVAL, { x: 9.7, y: -2.2, w: 6.5, h: 6.5, fill: { color: TEAL, transparency: 78 }, line: { type: "none" } });
  s.addShape(pres.shapes.OVAL, { x: 11.2, y: 3.4, w: 4.5, h: 4.5, fill: { color: MINT, transparency: 82 }, line: { type: "none" } });
  iconBadge(s, "FaGraduationCap", 0.85, 0.9, 0.95, TEAL, "white");
  s.addText("ĐỒ ÁN TỐT NGHIỆP", { x: 0.9, y: 2.15, w: 10, h: 0.4, fontFace: BODY, fontSize: 14, bold: true, color: LIGHT_MINT, charSpacing: 4, margin: 0 });
  s.addText("Hệ thống học tập trực tuyến\nvới kiểm tra tập trung bằng webcam\nvà quiz thích ứng", { x: 0.9, y: 2.65, w: 11, h: 2.3, fontFace: HEAD, fontSize: 38, bold: true, color: WHITE, lineSpacing: 46, margin: 0 });
  s.addShape(pres.shapes.LINE, { x: 0.95, y: 5.25, w: 2.4, h: 0, line: { color: ACCENT, width: 3 } });
  s.addText("Ứng dụng AI nhận diện khuôn mặt để cá nhân hóa trải nghiệm học tập", { x: 0.9, y: 5.45, w: 10.5, h: 0.5, fontFace: BODY, fontSize: 16, italic: true, color: "CBD5E1", margin: 0 });
  s.addText([{ text: "Sinh viên thực hiện:  ", options: { color: MUTED } }, { text: "_______________", options: { color: "CBD5E1" } }, { text: "        GVHD:  ", options: { color: MUTED } }, { text: "_______________", options: { color: "CBD5E1" } }], { x: 0.9, y: 6.45, w: 11.5, h: 0.4, fontFace: BODY, fontSize: 13, margin: 0 });
  s.addNotes("Chào thầy/cô và hội đồng. Em xin trình bày đồ án 'Hệ thống học tập trực tuyến với kiểm tra tập trung bằng webcam và quiz thích ứng'. Điểm khác biệt là ứng dụng AI nhận diện khuôn mặt ngay trên trình duyệt để theo dõi sự tập trung, kết hợp quiz tự điều chỉnh độ khó theo năng lực người học.");

  // ===== 2. AGENDA =====
  n = 2; s = lightHead("Nội dung", "Nội dung trình bày", n);
  const agenda = [
    { k: "FaBullseye", t: "Giới thiệu & mục tiêu", d: "Bối cảnh, vấn đề, phạm vi đề tài" },
    { k: "FaCode", t: "Công nghệ & kiến trúc", d: "Stack, kiến trúc phân tầng, cơ sở dữ liệu" },
    { k: "FaCogs", t: "Chức năng hệ thống", d: "Phía người học và quản trị viên" },
    { k: "FaBrain", t: "Hai tính năng AI nổi bật", d: "Giám sát tập trung & quiz thích ứng" },
    { k: "FaChartLine", t: "Kết quả & đánh giá", d: "Demo, hạn chế, hướng phát triển" },
  ];
  agenda.forEach((a, i) => {
    const y = 2.05 + i * 0.92;
    s.addShape(pres.shapes.ROUNDED_RECTANGLE, { x: 0.6, y, w: 9.5, h: 0.78, fill: { color: i % 2 ? CARD : CARD2 }, line: { type: "none" }, rectRadius: 0.08 });
    s.addText(`0${i + 1}`, { x: 0.85, y, w: 0.9, h: 0.78, fontFace: HEAD, fontSize: 26, bold: true, color: TEAL, margin: 0, valign: "middle" });
    iconBadge(s, a.k, 1.85, y + 0.13, 0.52, TEAL, "white");
    s.addText(a.t, { x: 2.6, y: y + 0.08, w: 7.3, h: 0.4, fontFace: HEAD, fontSize: 16, bold: true, color: INK, margin: 0 });
    s.addText(a.d, { x: 2.6, y: y + 0.44, w: 7.3, h: 0.3, fontFace: BODY, fontSize: 12, color: MUTED, margin: 0 });
  });
  s.addShape(pres.shapes.ROUNDED_RECTANGLE, { x: 10.4, y: 2.05, w: 2.3, h: 4.55, fill: { color: DARK }, line: { type: "none" }, rectRadius: 0.12 });
  iconBadge(s, "FaListUl", 11.2, 2.75, 0.7, TEAL, "white");
  s.addText("5", { x: 10.4, y: 3.6, w: 2.3, h: 1.0, fontFace: HEAD, fontSize: 52, bold: true, color: WHITE, align: "center", margin: 0 });
  s.addText("phần chính", { x: 10.4, y: 4.65, w: 2.3, h: 0.4, fontFace: BODY, fontSize: 14, color: LIGHT_MINT, align: "center", margin: 0 });
  s.addNotes("Bài trình bày gồm 5 phần: giới thiệu và mục tiêu, công nghệ và kiến trúc, chức năng hệ thống, hai tính năng AI nổi bật, và cuối cùng là kết quả cùng hướng phát triển.");

  // ===== 3. ĐẶT VẤN ĐỀ =====
  n = 3; s = lightHead("Đặt vấn đề", "Vì sao cần đề tài này?", n);
  threeCards(s, [
    { k: "FaEye", t: "Khó kiểm soát tập trung", d: "Học online thiếu giám sát, người học dễ mất tập trung, buồn ngủ mà không ai nhắc nhở." },
    { k: "FaListOl", t: "Bài kiểm tra cố định", d: "Quiz truyền thống dùng chung một bộ đề, không phù hợp với năng lực từng người." },
    { k: "FaChartLine", t: "Thiếu dữ liệu phản hồi", d: "Giảng viên khó biết người học yếu ở đâu để đưa ra gợi ý cải thiện kịp thời." },
  ]);
  s.addNotes("Học trực tuyến phổ biến nhưng tồn tại 3 vấn đề: không kiểm soát được tập trung, bài kiểm tra cố định không phân hóa, và thiếu dữ liệu phản hồi. Đề tài giải quyết cả 3 bằng AI webcam và quiz thích ứng.");

  // ===== 4. THỰC TRẠNG (stat callouts) =====
  n = 4; s = lightHead("Thực trạng", "Học trực tuyến — cơ hội và thách thức", n);
  const stt = [
    { num: "70%", l: "người học tự nhận\ndễ mất tập trung khi học online", c: ACCENT },
    { num: "1 đề", l: "dùng chung cho mọi trình độ\nở quiz truyền thống", c: TEAL },
    { num: "0", l: "phản hồi cá nhân hóa\ntrong phần lớn hệ thống hiện nay", c: DARK },
  ];
  let sx = 0.6;
  stt.forEach((st, i) => {
    s.addShape(pres.shapes.ROUNDED_RECTANGLE, { x: sx, y: 2.2, w: 3.9, h: 2.6, fill: { color: i % 2 ? CARD2 : CARD }, line: { type: "none" }, rectRadius: 0.12, shadow: sh() });
    s.addText(st.num, { x: sx, y: 2.45, w: 3.9, h: 1.1, fontFace: HEAD, fontSize: 50, bold: true, color: st.c, align: "center", margin: 0 });
    s.addText(st.l, { x: sx + 0.25, y: 3.6, w: 3.4, h: 1.0, fontFace: BODY, fontSize: 13.5, color: INK, align: "center", margin: 0, lineSpacing: 18 });
    sx += 4.1;
  });
  s.addShape(pres.shapes.ROUNDED_RECTANGLE, { x: 0.6, y: 5.15, w: 12.1, h: 1.25, fill: { color: DARK }, line: { type: "none" }, rectRadius: 0.12 });
  s.addText([{ text: "Khoảng trống:  ", options: { bold: true, color: LIGHT_MINT } }, { text: "cần một hệ thống vừa giám sát sự tập trung, vừa cá nhân hóa bài kiểm tra theo năng lực của từng người học.", options: { color: "E2E8F0" } }], { x: 1.0, y: 5.15, w: 11.3, h: 1.25, fontFace: BODY, fontSize: 15.5, margin: 0, valign: "middle", lineSpacing: 22 });
  s.addNotes("Các con số minh họa cho khoảng trống: người học dễ mất tập trung, quiz dùng chung một đề, và hầu như không có phản hồi cá nhân hóa. Đây chính là khoảng trống mà đề tài hướng tới lấp đầy. Lưu ý: số liệu mang tính minh họa, có thể thay bằng số liệu khảo sát thực tế của nhóm.");

  // ===== 5. MỤC TIÊU =====
  n = 5; s = lightHead("Mục tiêu", "Hệ thống hướng tới điều gì?", n);
  const goals = [
    { k: "FaVideo", t: "Xem video bài giảng", d: "Quản lý khóa học, bài học, theo dõi tiến trình." },
    { k: "FaCamera", t: "Giám sát tập trung", d: "Webcam + AI phát hiện tập trung / mất tập trung / buồn ngủ." },
    { k: "FaBolt", t: "Quiz thích ứng", d: "Tự động tăng/giảm độ khó theo năng lực người học." },
    { k: "FaLightbulb", t: "Phản hồi học tập", d: "Sinh feedback từ điểm quiz và điểm tập trung." },
    { k: "FaUserShield", t: "Quản trị nội dung", d: "Admin quản lý khóa học, bài giảng, câu hỏi." },
    { k: "FaChartLine", t: "Thống kê & Dashboard", d: "Theo dõi số liệu học tập từng học viên và toàn hệ thống." },
  ];
  goals.forEach((g, i) => {
    const col = i % 3, row = Math.floor(i / 3);
    const x = 0.6 + col * 4.1, y = 2.1 + row * 2.0;
    s.addShape(pres.shapes.ROUNDED_RECTANGLE, { x, y, w: 3.9, h: 1.8, fill: { color: i % 2 ? CARD : CARD2 }, line: { type: "none" }, rectRadius: 0.1 });
    iconBadge(s, g.k, x + 0.3, y + 0.32, 0.62, TEAL, "white");
    s.addText(g.t, { x: x + 1.1, y: y + 0.3, w: 2.7, h: 0.5, fontFace: HEAD, fontSize: 15, bold: true, color: INK, margin: 0, valign: "middle" });
    s.addText(g.d, { x: x + 0.3, y: y + 0.95, w: 3.4, h: 0.75, fontFace: BODY, fontSize: 11.5, color: MUTED, margin: 0, lineSpacing: 15 });
  });
  s.addNotes("6 nhóm mục tiêu. Người học: xem video, giám sát tập trung, làm quiz thích ứng, nhận phản hồi. Quản trị: quản lý nội dung và xem thống kê. Hai điểm cốt lõi là giám sát tập trung và quiz thích ứng.");

  // ===== 6. PHẠM VI =====
  n = 6; s = lightHead("Phạm vi", "Phạm vi & giới hạn đề tài", n);
  s.addShape(pres.shapes.ROUNDED_RECTANGLE, { x: 0.6, y: 2.1, w: 5.95, h: 4.4, fill: { color: CARD2 }, line: { type: "none" }, rectRadius: 0.12, shadow: sh() });
  iconBadge(s, "FaCheckCircle", 0.95, 2.45, 0.75, TEAL, "white");
  s.addText("Trong phạm vi", { x: 1.85, y: 2.45, w: 4.4, h: 0.75, fontFace: HEAD, fontSize: 18, bold: true, color: INK, margin: 0, valign: "middle" });
  s.addText(["Web app học tập (React + Spring Boot)", "AI nhận diện tập trung qua webcam", "Quiz thích ứng theo 3 mức độ khó", "Dashboard & thống kê cơ bản", "Quản trị khóa học / bài giảng / câu hỏi"].map(t => ({ text: t, options: { bullet: { code: "2713" }, color: INK, breakLine: true, paraSpaceAfter: 12 } })), { x: 1.0, y: 3.5, w: 5.3, h: 2.8, fontFace: BODY, fontSize: 14, margin: 0 });
  s.addShape(pres.shapes.ROUNDED_RECTANGLE, { x: 6.75, y: 2.1, w: 5.95, h: 4.4, fill: { color: CARD }, line: { type: "none" }, rectRadius: 0.12, shadow: sh() });
  iconBadge(s, "FaExclamationTriangle", 7.1, 2.45, 0.75, ACCENT, "white");
  s.addText("Ngoài phạm vi", { x: 8.0, y: 2.45, w: 4.4, h: 0.75, fontFace: HEAD, fontSize: 18, bold: true, color: INK, margin: 0, valign: "middle" });
  s.addText(["Ứng dụng di động (mobile native)", "Nhận diện danh tính bằng khuôn mặt (Face ID)", "Thanh toán / khóa học trả phí", "Triển khai hạ tầng cloud quy mô lớn", "Bảo mật nâng cao (JWT) — ở giai đoạn sau"].map(t => ({ text: t, options: { bullet: { code: "2715" }, color: INK, breakLine: true, paraSpaceAfter: 12 } })), { x: 7.15, y: 3.5, w: 5.3, h: 2.8, fontFace: BODY, fontSize: 14, margin: 0 });
  s.addNotes("Xác định rõ phạm vi giúp hội đồng đánh giá đúng. Trong phạm vi: web app với AI tập trung, quiz thích ứng, dashboard, quản trị nội dung. Ngoài phạm vi: mobile, Face ID nhận diện danh tính, thanh toán, và bảo mật JWT nâng cao sẽ làm ở giai đoạn sau.");

  // ===== 7. ĐỐI TƯỢNG / ACTORS =====
  n = 7; s = lightHead("Người dùng", "Đối tượng sử dụng hệ thống", n);
  // Student
  s.addShape(pres.shapes.ROUNDED_RECTANGLE, { x: 0.6, y: 2.1, w: 5.95, h: 4.4, fill: { color: CARD2 }, line: { type: "none" }, rectRadius: 0.12, shadow: sh() });
  iconBadge(s, "FaUserGraduate", 0.95, 2.45, 0.85, TEAL, "white");
  s.addText("Người học (Student)", { x: 2.0, y: 2.45, w: 4.3, h: 0.85, fontFace: HEAD, fontSize: 19, bold: true, color: INK, margin: 0, valign: "middle" });
  s.addText(["Đăng ký / đăng nhập / đăng xuất", "Xem khóa học & video bài giảng", "Bật webcam giám sát tập trung", "Làm quiz thích ứng sau bài học", "Nhận feedback & xem tiến trình"].map(t => ({ text: t, options: { bullet: { code: "2713" }, color: INK, breakLine: true, paraSpaceAfter: 11 } })), { x: 1.0, y: 3.55, w: 5.3, h: 2.8, fontFace: BODY, fontSize: 14.5, margin: 0 });
  // Admin
  s.addShape(pres.shapes.ROUNDED_RECTANGLE, { x: 6.75, y: 2.1, w: 5.95, h: 4.4, fill: { color: DARK }, line: { type: "none" }, rectRadius: 0.12, shadow: sh() });
  iconBadge(s, "FaUserShield", 7.1, 2.45, 0.85, ACCENT, "white");
  s.addText("Quản trị viên (Admin)", { x: 8.15, y: 2.45, w: 4.3, h: 0.85, fontFace: HEAD, fontSize: 19, bold: true, color: WHITE, margin: 0, valign: "middle" });
  s.addText(["Quản lý khóa học (CRUD)", "Quản lý bài giảng & upload video", "Quản lý câu hỏi theo độ khó", "Dashboard thống kê toàn hệ thống", "Theo dõi focus score & kết quả quiz"].map(t => ({ text: t, options: { bullet: { code: "2713" }, color: "E2E8F0", breakLine: true, paraSpaceAfter: 11 } })), { x: 7.15, y: 3.55, w: 5.3, h: 2.8, fontFace: BODY, fontSize: 14.5, margin: 0 });
  s.addNotes("Hệ thống có 2 actor: người học và quản trị viên. Phân quyền bằng route guard ở frontend dựa trên vai trò lưu trong phiên đăng nhập.");

  // ===== 8. CÔNG NGHỆ =====
  n = 8; s = lightHead("Công nghệ", "Công nghệ sử dụng", n);
  const stacks = [
    { k: "FaReact", h: "Frontend", items: ["React 19 + Vite", "React Router, Axios", "face-api.js (AI webcam)"] },
    { k: "FaJava", h: "Backend", items: ["Java 17 + Spring Boot 3", "Spring Data JPA", "REST API + DTO pattern"] },
    { k: "FaDatabase", h: "Database", items: ["MySQL", "11 bảng dữ liệu", "Khóa ngoại liên kết rõ ràng"] },
  ];
  let bx = 0.6;
  for (const st of stacks) {
    s.addShape(pres.shapes.ROUNDED_RECTANGLE, { x: bx, y: 2.15, w: 3.9, h: 3.9, fill: { color: WHITE }, line: { color: "E2E8F0", width: 1 }, rectRadius: 0.1, shadow: sh() });
    s.addShape(pres.shapes.RECTANGLE, { x: bx, y: 2.15, w: 3.9, h: 0.12, fill: { color: TEAL } });
    iconBadge(s, st.k, bx + 0.35, 2.5, 0.85, DARK, "white");
    s.addText(st.h, { x: bx + 1.4, y: 2.5, w: 2.4, h: 0.85, fontFace: HEAD, fontSize: 21, bold: true, color: INK, margin: 0, valign: "middle" });
    s.addText(st.items.map(t => ({ text: t, options: { bullet: { code: "2022", indent: 14 }, color: INK, breakLine: true, paraSpaceAfter: 10 } })), { x: bx + 0.4, y: 3.65, w: 3.2, h: 2.2, fontFace: BODY, fontSize: 14, color: INK, margin: 0 });
    bx += 4.1;
  }
  s.addNotes("Frontend React 19 + Vite, AI chạy bằng face-api.js trên trình duyệt. Backend Spring Boot phân tầng Controller–Service–Repository. Database MySQL 11 bảng. AI xử lý phía client nên không gửi hình ảnh lên server.");

  // ===== 9. VÌ SAO CHỌN STACK =====
  n = 9; s = lightHead("Lựa chọn công nghệ", "Vì sao chọn các công nghệ này?", n);
  rowList(s, [
    { k: "FaReact", t: "React + Vite", d: "Component tái sử dụng, dev nhanh, cộng đồng lớn" },
    { k: "FaBrain", t: "face-api.js", d: "Chạy ML ngay trên trình duyệt, không cần server AI" },
    { k: "FaJava", t: "Spring Boot", d: "Khung backend trưởng thành, JPA giảm code thủ công" },
    { k: "FaDatabase", t: "MySQL", d: "Quan hệ rõ ràng, phù hợp dữ liệu có cấu trúc" },
  ], 0.6, 2.1, 6.4, { rh: 1.08 });
  s.addShape(pres.shapes.ROUNDED_RECTANGLE, { x: 7.4, y: 2.1, w: 5.3, h: 4.45, fill: { color: DARK }, line: { type: "none" }, rectRadius: 0.12, shadow: sh() });
  iconBadge(s, "FaLightbulb", 7.75, 2.45, 0.8, ACCENT, "white");
  s.addText("Tiêu chí lựa chọn", { x: 8.7, y: 2.45, w: 3.7, h: 0.8, fontFace: HEAD, fontSize: 17, bold: true, color: WHITE, margin: 0, valign: "middle" });
  s.addText(["Miễn phí, mã nguồn mở", "Tài liệu & cộng đồng phong phú", "Phù hợp năng lực nhóm", "Dễ mở rộng về sau"].map(t => ({ text: t, options: { bullet: { code: "2022" }, color: "E2E8F0", breakLine: true, paraSpaceAfter: 14 } })), { x: 7.8, y: 3.55, w: 4.6, h: 2.7, fontFace: BODY, fontSize: 14.5, margin: 0 });
  s.addNotes("Lý do chọn công nghệ: React giúp dev nhanh, face-api.js cho phép chạy AI ngay trên trình duyệt không cần server AI riêng, Spring Boot là khung backend trưởng thành, MySQL phù hợp dữ liệu có cấu trúc. Tất cả đều miễn phí, mã nguồn mở, tài liệu phong phú và phù hợp năng lực nhóm.");

  // ===== 10. KIẾN TRÚC =====
  n = 10; s = darkHead("Kiến trúc", "Kiến trúc tổng quan", n);
  const blocks = [
    { k: "FaReact", t: "Frontend (React)", d: "Giao diện học tập + AI webcam xử lý cục bộ", c: TEAL },
    { k: "FaServer", t: "Backend (Spring Boot)", d: "REST API · Service · Repository", c: MINT },
    { k: "FaDatabase", t: "Database (MySQL)", d: "Lưu user, khóa học, quiz, focus logs", c: ACCENT },
  ];
  let cx = 0.9;
  blocks.forEach((b, i) => {
    s.addShape(pres.shapes.ROUNDED_RECTANGLE, { x: cx, y: 2.6, w: 3.4, h: 2.5, fill: { color: "12393F" }, line: { color: b.c, width: 1.5 }, rectRadius: 0.12 });
    iconBadge(s, b.k, cx + 0.35, 2.95, 0.8, b.c, "white");
    s.addText(b.t, { x: cx + 0.3, y: 3.9, w: 2.9, h: 0.5, fontFace: HEAD, fontSize: 16, bold: true, color: WHITE, margin: 0 });
    s.addText(b.d, { x: cx + 0.3, y: 4.35, w: 2.9, h: 0.7, fontFace: BODY, fontSize: 12, color: "B6CBCC", margin: 0, lineSpacing: 16 });
    if (i < 2) s.addImage({ data: ic.FaArrowRight.accent, x: cx + 3.5, y: 3.55, w: 0.45, h: 0.45 });
    cx += 3.95;
  });
  s.addShape(pres.shapes.ROUNDED_RECTANGLE, { x: 0.9, y: 5.45, w: 11.4, h: 1.0, fill: { color: TEAL, transparency: 80 }, line: { type: "none" }, rectRadius: 0.1 });
  s.addText([{ text: "Luồng dữ liệu:  ", options: { bold: true, color: LIGHT_MINT } }, { text: "Người học thao tác → React gọi REST API → Spring Boot xử lý → MySQL lưu trữ → trả JSON về giao diện.", options: { color: "E2E8F0" } }], { x: 1.2, y: 5.55, w: 10.8, h: 0.8, fontFace: BODY, fontSize: 14, margin: 0, valign: "middle" });
  s.addNotes("Kiến trúc 3 tầng: React giao diện, Spring Boot nghiệp vụ, MySQL lưu trữ. Giao tiếp qua REST API trả JSON. AI webcam tách riêng xử lý tại trình duyệt, chỉ gửi về backend điểm tập trung chứ không gửi hình ảnh.");

  // ===== 11. PHÂN TẦNG BACKEND =====
  n = 11; s = lightHead("Backend", "Kiến trúc phân tầng backend", n);
  const layers = [
    { k: "FaCode", t: "Controller", d: "Nhận request, định nghĩa REST API endpoints", c: TEAL },
    { k: "FaCogs", t: "Service", d: "Xử lý nghiệp vụ: quiz thích ứng, tính điểm, feedback", c: MINT },
    { k: "FaDatabase", t: "Repository", d: "Truy vấn dữ liệu qua Spring Data JPA", c: ACCENT },
    { k: "FaLayerGroup", t: "Entity / DTO", d: "Ánh xạ bảng & truyền dữ liệu giữa các tầng", c: DARK },
  ];
  layers.forEach((l, i) => {
    const y = 2.15 + i * 1.05;
    s.addShape(pres.shapes.ROUNDED_RECTANGLE, { x: 0.6, y, w: 8.2, h: 0.9, fill: { color: i % 2 ? CARD : CARD2 }, line: { type: "none" }, rectRadius: 0.08 });
    iconBadge(s, l.k, 0.85, y + 0.15, 0.6, l.c, "white");
    s.addText(l.t, { x: 1.65, y: y + 0.12, w: 2.4, h: 0.65, fontFace: HEAD, fontSize: 16, bold: true, color: INK, margin: 0, valign: "middle" });
    s.addText(l.d, { x: 4.0, y: y + 0.12, w: 4.6, h: 0.65, fontFace: BODY, fontSize: 12.5, color: MUTED, margin: 0, valign: "middle" });
    if (i < 3) s.addImage({ data: ic.FaArrowRight.dark, x: 1.0, y: y + 0.92, w: 0.26, h: 0.26, rotate: 90 });
  });
  s.addShape(pres.shapes.ROUNDED_RECTANGLE, { x: 9.1, y: 2.15, w: 3.6, h: 4.3, fill: { color: DARK }, line: { type: "none" }, rectRadius: 0.12 });
  iconBadge(s, "FaProjectDiagram", 9.45, 2.5, 0.75, TEAL, "white");
  s.addText("Tách lớp rõ ràng", { x: 9.45, y: 3.45, w: 3.0, h: 0.5, fontFace: HEAD, fontSize: 16, bold: true, color: WHITE, margin: 0 });
  s.addText("Mỗi tầng một trách nhiệm → dễ bảo trì, dễ kiểm thử và mở rộng từng phần độc lập.", { x: 9.45, y: 4.0, w: 3.0, h: 2.0, fontFace: BODY, fontSize: 13, color: "B6CBCC", margin: 0, lineSpacing: 19 });
  s.addNotes("Backend tổ chức theo 4 tầng: Controller nhận request và định nghĩa API, Service chứa nghiệp vụ như thuật toán quiz thích ứng và tính điểm, Repository truy vấn dữ liệu qua JPA, Entity/DTO ánh xạ bảng và truyền dữ liệu. Tách lớp giúp dễ bảo trì và kiểm thử.");

  // ===== 12. CSDL BẢNG =====
  n = 12; s = lightHead("Dữ liệu", "Cơ sở dữ liệu — 11 bảng chính", n);
  const rows = [
    ["Bảng", "Vai trò chính"],
    ["users", "Người dùng, vai trò, current_level"],
    ["courses / lessons", "Khóa học và bài giảng (kèm video)"],
    ["questions", "Câu hỏi quiz phân theo độ khó"],
    ["quiz_attempts / quiz_answers", "Lượt làm bài và từng câu trả lời"],
    ["focus_logs", "Trạng thái & điểm tập trung qua webcam"],
    ["learning_progress", "Tiến trình hoàn thành từng bài học"],
    ["feedbacks", "Phản hồi sinh từ điểm quiz + tập trung"],
  ];
  s.addTable(rows, { x: 0.6, y: 2.1, w: 8.0, colW: [3.1, 4.9], rowH: 0.52, fontFace: BODY, fontSize: 13.5, color: INK, border: { type: "solid", pt: 1, color: "E2E8F0" }, align: "left", valign: "middle", fill: { color: "FFFFFF" } });
  s.addShape(pres.shapes.RECTANGLE, { x: 0.6, y: 2.1, w: 8.0, h: 0.52, fill: { color: DARK }, line: { type: "none" } });
  s.addText("Bảng", { x: 0.7, y: 2.1, w: 3.0, h: 0.52, fontFace: BODY, fontSize: 13.5, bold: true, color: WHITE, valign: "middle", margin: 0 });
  s.addText("Vai trò chính", { x: 3.8, y: 2.1, w: 4.7, h: 0.52, fontFace: BODY, fontSize: 13.5, bold: true, color: WHITE, valign: "middle", margin: 0 });
  s.addShape(pres.shapes.ROUNDED_RECTANGLE, { x: 8.95, y: 2.1, w: 3.75, h: 4.25, fill: { color: CARD2 }, line: { type: "none" }, rectRadius: 0.12 });
  iconBadge(s, "FaLayerGroup", 9.3, 2.45, 0.8, TEAL, "white");
  s.addText("Thiết kế chuẩn hóa", { x: 9.3, y: 3.45, w: 3.1, h: 0.5, fontFace: HEAD, fontSize: 17, bold: true, color: INK, margin: 0 });
  s.addText("Các bảng liên kết bằng khóa ngoại rõ ràng, áp dụng JPA Entity mapping và pattern Repository – Service – Controller.", { x: 9.3, y: 4.0, w: 3.1, h: 2.0, fontFace: BODY, fontSize: 13, color: MUTED, margin: 0, lineSpacing: 19 });
  s.addNotes("11 bảng. Cốt lõi: users, courses, lessons, questions. Ghi nhận hoạt động: quiz_attempts, quiz_answers, focus_logs, learning_progress, feedbacks. Trường current_level trong users quyết định độ khó quiz.");

  // ===== 13. QUAN HỆ DỮ LIỆU (ERD-ish) =====
  n = 13; s = darkHead("Dữ liệu", "Quan hệ dữ liệu chính", n);
  // central user -> course -> lesson -> question/quiz/focus
  function erdNode(x, y, w, label, color) {
    s.addShape(pres.shapes.ROUNDED_RECTANGLE, { x, y, w, h: 0.75, fill: { color }, line: { type: "none" }, rectRadius: 0.08, shadow: sh() });
    s.addText(label, { x, y, w, h: 0.75, fontFace: BODY, fontSize: 13.5, bold: true, color: WHITE, align: "center", valign: "middle", margin: 0 });
  }
  erdNode(0.9, 3.3, 2.2, "users", TEAL);
  erdNode(4.0, 2.2, 2.2, "courses", MINT);
  erdNode(4.0, 4.4, 2.2, "focus_logs", ACCENT);
  erdNode(7.1, 2.2, 2.2, "lessons", MINT);
  erdNode(7.1, 4.4, 2.2, "quiz_attempts", ACCENT);
  erdNode(10.2, 2.2, 2.2, "questions", "12393F");
  erdNode(10.2, 4.4, 2.2, "quiz_answers", "12393F");
  function link(x1, y1, x2, y2) {
    const x = Math.min(x1, x2), y = Math.min(y1, y2);
    const w = Math.abs(x2 - x1), h = Math.abs(y2 - y1);
    const flipV = (y2 < y1); // line going upward
    s.addShape(pres.shapes.LINE, { x, y, w, h, flipV, line: { color: LIGHT_MINT, width: 1.5 } });
  }
  link(3.1, 3.6, 4.0, 2.6); link(3.1, 3.7, 4.0, 4.7);
  link(6.2, 2.55, 7.1, 2.55); link(6.2, 4.75, 7.1, 4.75);
  link(9.3, 2.55, 10.2, 2.55); link(9.3, 4.75, 10.2, 4.75);
  link(8.2, 2.95, 8.2, 4.4);
  s.addText("Một người học → nhiều khóa học, bài học, lượt quiz và bản ghi tập trung. Tất cả ràng buộc bằng khóa ngoại.", { x: 0.9, y: 5.7, w: 11.5, h: 0.6, fontFace: BODY, fontSize: 13.5, italic: true, color: "CBD5E1", align: "center", margin: 0 });
  s.addNotes("Sơ đồ quan hệ rút gọn: users là trung tâm, liên kết tới courses và focus_logs. Courses chứa lessons, lessons chứa questions. Mỗi lần làm bài tạo một quiz_attempt gồm nhiều quiz_answers. Tất cả liên kết bằng khóa ngoại, thể hiện quan hệ một–nhiều.");

  // ===== 14. CHỨC NĂNG NGƯỜI HỌC chi tiết =====
  n = 14; s = lightHead("Chức năng · Người học", "Trải nghiệm của người học", n);
  rowList(s, [
    { k: "FaSignInAlt", t: "Tài khoản", d: "Đăng ký, đăng nhập, quản lý hồ sơ cá nhân" },
    { k: "FaVideo", t: "Học bài giảng", d: "Xem video, ghi chú, theo dõi tiến trình hoàn thành" },
    { k: "FaCamera", t: "Giám sát tập trung", d: "Bật webcam, AI cảnh báo khi mất tập trung / buồn ngủ" },
    { k: "FaBolt", t: "Quiz thích ứng", d: "Làm bài, độ khó tự điều chỉnh theo năng lực" },
    { k: "FaComments", t: "Nhận phản hồi", d: "Xem feedback và gợi ý cải thiện sau mỗi bài" },
  ], 0.6, 2.05, 12.1, { rh: 0.95 });
  s.addNotes("Đi sâu trải nghiệm người học theo trình tự thực tế: tạo tài khoản, vào học bài giảng có ghi chú và theo dõi tiến trình, trong khi học webcam giám sát tập trung, sau đó làm quiz thích ứng và cuối cùng nhận phản hồi cá nhân hóa.");

  // ===== 15. CHỨC NĂNG ADMIN chi tiết =====
  n = 15; s = lightHead("Chức năng · Quản trị", "Công cụ cho quản trị viên", n);
  const adm = [
    { k: "FaLayerGroup", t: "Quản lý khóa học", d: "Tạo, sửa, xóa và xuất bản khóa học" },
    { k: "FaUpload", t: "Quản lý bài giảng", d: "Thêm bài học, upload video, sắp xếp thứ tự" },
    { k: "FaQuestionCircle", t: "Quản lý câu hỏi", d: "Soạn câu hỏi, phân loại theo độ khó" },
    { k: "FaTachometerAlt", t: "Dashboard thống kê", d: "Số học viên, điểm quiz, focus score, lượt xem" },
  ];
  adm.forEach((a, i) => {
    const col = i % 2, row = Math.floor(i / 2);
    const x = 0.6 + col * 6.15, y = 2.15 + row * 2.15;
    s.addShape(pres.shapes.ROUNDED_RECTANGLE, { x, y, w: 5.9, h: 1.9, fill: { color: i % 2 ? CARD : CARD2 }, line: { type: "none" }, rectRadius: 0.12, shadow: sh() });
    iconBadge(s, a.k, x + 0.35, y + 0.35, 0.8, TEAL, "white");
    s.addText(a.t, { x: x + 1.45, y: y + 0.4, w: 4.2, h: 0.6, fontFace: HEAD, fontSize: 17, bold: true, color: INK, margin: 0, valign: "middle" });
    s.addText(a.d, { x: x + 1.45, y: y + 1.0, w: 4.2, h: 0.75, fontFace: BODY, fontSize: 13, color: MUTED, margin: 0, lineSpacing: 17 });
  });
  s.addNotes("Quản trị viên có 4 nhóm công cụ: quản lý khóa học (kể cả xuất bản), quản lý bài giảng và upload video, quản lý ngân hàng câu hỏi theo độ khó, và dashboard thống kê toàn hệ thống.");

  // ===== 16. TÍNH NĂNG 1: AI FOCUS =====
  n = 16; s = lightHead("Tính năng nổi bật 01", "AI giám sát tập trung qua webcam", n);
  const steps = [
    { k: "FaCamera", t: "Bật webcam", d: "Xin quyền camera, xử lý ngay trên trình duyệt" },
    { k: "FaBrain", t: "Nhận diện khuôn mặt", d: "face-api.js detect mỗi 2 giây" },
    { k: "FaEye", t: "Phân tích trạng thái", d: "Mắt nhắm → buồn ngủ · Quay đầu → mất tập trung" },
    { k: "FaChartLine", t: "Ghi điểm tập trung", d: "Lưu focus log mỗi 15 giây về backend" },
  ];
  steps.forEach((p, i) => {
    const y = 2.15 + i * 1.12;
    s.addShape(pres.shapes.ROUNDED_RECTANGLE, { x: 0.6, y, w: 6.4, h: 0.95, fill: { color: i % 2 ? CARD : CARD2 }, line: { type: "none" }, rectRadius: 0.08 });
    iconBadge(s, p.k, 0.85, y + 0.17, 0.6, TEAL, "white");
    s.addText(`${i + 1}. ${p.t}`, { x: 1.65, y: y + 0.12, w: 5.2, h: 0.4, fontFace: HEAD, fontSize: 15, bold: true, color: INK, margin: 0 });
    s.addText(p.d, { x: 1.65, y: y + 0.5, w: 5.2, h: 0.35, fontFace: BODY, fontSize: 11.5, color: MUTED, margin: 0 });
  });
  s.addShape(pres.shapes.ROUNDED_RECTANGLE, { x: 7.4, y: 2.15, w: 5.3, h: 4.5, fill: { color: DARK }, line: { type: "none" }, rectRadius: 0.12, shadow: sh() });
  s.addText("4 trạng thái phát hiện", { x: 7.7, y: 2.4, w: 4.8, h: 0.5, fontFace: HEAD, fontSize: 17, bold: true, color: WHITE, margin: 0 });
  const states = [{ t: "Focused — Tập trung", c: MINT }, { t: "Distracted — Mất tập trung", c: ACCENT }, { t: "Drowsy — Buồn ngủ", c: "F97362" }, { t: "No face — Không có mặt", c: "94A3B8" }];
  states.forEach((st, i) => {
    const y = 3.1 + i * 0.82;
    s.addShape(pres.shapes.OVAL, { x: 7.75, y: y + 0.06, w: 0.28, h: 0.28, fill: { color: st.c } });
    s.addText(st.t, { x: 8.2, y, w: 4.2, h: 0.45, fontFace: BODY, fontSize: 14.5, color: "E2E8F0", margin: 0, valign: "middle" });
  });
  s.addText("Riêng tư: hình ảnh webcam KHÔNG gửi lên server", { x: 7.7, y: 6.15, w: 4.8, h: 0.4, fontFace: BODY, fontSize: 11.5, italic: true, color: LIGHT_MINT, margin: 0 });
  s.addNotes("Tính năng nổi bật 1. Quy trình 4 bước: bật webcam, AI nhận diện mặt mỗi 2 giây, phân tích độ mở mắt và hướng đầu, ghi điểm tập trung mỗi 15 giây. Có 4 trạng thái. Nhấn mạnh: xử lý cục bộ, không gửi hình ảnh lên server.");

  // ===== 17. CÁCH AI HOẠT ĐỘNG (EAR / head pose) =====
  n = 17; s = darkHead("Tính năng nổi bật 01", "AI phân tích thế nào?", n);
  // left EAR
  s.addShape(pres.shapes.ROUNDED_RECTANGLE, { x: 0.9, y: 2.2, w: 5.6, h: 4.2, fill: { color: "12393F" }, line: { color: TEAL, width: 1.3 }, rectRadius: 0.12 });
  iconBadge(s, "FaEye", 1.25, 2.55, 0.75, TEAL, "white");
  s.addText("Phát hiện buồn ngủ (EAR)", { x: 2.15, y: 2.55, w: 4.1, h: 0.75, fontFace: HEAD, fontSize: 16, bold: true, color: WHITE, margin: 0, valign: "middle" });
  s.addText([
    { text: "Eye Aspect Ratio", options: { bold: true, color: LIGHT_MINT, breakLine: true } },
    { text: "Đo tỉ lệ mở của mắt qua 6 điểm mốc.", options: { color: "CBD5E1", breakLine: true, paraSpaceAfter: 8 } },
    { text: "EAR < 0.22 ", options: { bold: true, color: ACCENT } },
    { text: "kéo dài → mắt nhắm → cảnh báo buồn ngủ.", options: { color: "CBD5E1" } },
  ], { x: 1.3, y: 3.55, w: 5.0, h: 2.6, fontFace: BODY, fontSize: 14, margin: 0, lineSpacing: 21 });
  // right head pose
  s.addShape(pres.shapes.ROUNDED_RECTANGLE, { x: 6.8, y: 2.2, w: 5.6, h: 4.2, fill: { color: "12393F" }, line: { color: ACCENT, width: 1.3 }, rectRadius: 0.12 });
  iconBadge(s, "FaCrosshairs", 7.15, 2.55, 0.75, ACCENT, "white");
  s.addText("Phát hiện mất tập trung (head pose)", { x: 8.05, y: 2.55, w: 4.1, h: 0.75, fontFace: HEAD, fontSize: 15.5, bold: true, color: WHITE, margin: 0, valign: "middle" });
  s.addText([
    { text: "Ước lượng hướng đầu", options: { bold: true, color: LIGHT_MINT, breakLine: true } },
    { text: "Dựa trên vị trí mũi so với hai mắt và cằm.", options: { color: "CBD5E1", breakLine: true, paraSpaceAfter: 8 } },
    { text: "Lệch quá ngưỡng ", options: { bold: true, color: ACCENT } },
    { text: "→ đang nhìn đi chỗ khác → cảnh báo mất tập trung.", options: { color: "CBD5E1" } },
  ], { x: 7.2, y: 3.55, w: 5.0, h: 2.6, fontFace: BODY, fontSize: 14, margin: 0, lineSpacing: 21 });
  s.addNotes("Giải thích kỹ thuật để thể hiện hiểu sâu. EAR — Eye Aspect Ratio — đo tỉ lệ mở mắt qua 6 điểm landmark; khi EAR dưới 0.22 kéo dài nghĩa là mắt nhắm, cảnh báo buồn ngủ. Head pose ước lượng hướng đầu dựa vào vị trí mũi so với mắt và cằm; lệch quá ngưỡng nghĩa là nhìn đi chỗ khác, cảnh báo mất tập trung.");

  // ===== 18. BẢO MẬT WEBCAM / RIÊNG TƯ =====
  n = 18; s = lightHead("Tính năng nổi bật 01", "Riêng tư & xử lý cục bộ", n);
  threeCards(s, [
    { k: "FaLock", t: "Không gửi hình ảnh", d: "Toàn bộ phân tích khuôn mặt diễn ra trên trình duyệt người dùng." },
    { k: "FaChartLine", t: "Chỉ gửi điểm số", d: "Backend chỉ nhận trạng thái và điểm tập trung dạng số, không nhận ảnh/video." },
    { k: "FaShieldAlt", t: "Người dùng chủ động", d: "Người học tự bật/tắt camera, có thể dừng giám sát bất cứ lúc nào." },
  ]);
  s.addNotes("Một điểm hội đồng thường hỏi là quyền riêng tư. Trả lời: toàn bộ AI xử lý cục bộ trên trình duyệt, chỉ gửi điểm tập trung dạng số về server chứ không gửi ảnh hay video, và người học hoàn toàn chủ động bật tắt camera. Đây là thiết kế tôn trọng quyền riêng tư.");

  // ===== 19. TÍNH NĂNG 2: QUIZ =====
  n = 19; s = lightHead("Tính năng nổi bật 02", "Quiz thích ứng theo năng lực", n);
  const levels = [{ t: "Basic", d: "Cơ bản", c: MINT }, { t: "Medium", d: "Trung bình", c: TEAL }, { t: "Hard", d: "Khó", c: DARK }];
  levels.forEach((l, i) => {
    const x = 0.6 + i * 2.0, hgt = 1.4 + i * 0.5, y = 4.7 - hgt;
    s.addShape(pres.shapes.ROUNDED_RECTANGLE, { x, y, w: 1.7, h: hgt, fill: { color: l.c }, line: { type: "none" }, rectRadius: 0.08 });
    s.addText(l.t, { x, y: y + 0.15, w: 1.7, h: 0.4, fontFace: HEAD, fontSize: 15, bold: true, color: WHITE, align: "center", margin: 0 });
    s.addText(l.d, { x, y: y + hgt - 0.45, w: 1.7, h: 0.35, fontFace: BODY, fontSize: 11, color: "E8F3F2", align: "center", margin: 0 });
    if (i < 2) s.addImage({ data: ic.FaArrowRight.teal, x: x + 1.72, y: 4.1, w: 0.3, h: 0.3 });
  });
  s.addText("Độ khó tăng dần theo năng lực", { x: 0.6, y: 4.85, w: 6, h: 0.4, fontFace: BODY, fontSize: 12, italic: true, color: MUTED, margin: 0 });
  s.addShape(pres.shapes.ROUNDED_RECTANGLE, { x: 7.1, y: 2.1, w: 5.6, h: 4.4, fill: { color: CARD }, line: { type: "none" }, rectRadius: 0.12, shadow: sh() });
  iconBadge(s, "FaBolt", 7.45, 2.4, 0.75, ACCENT, "white");
  s.addText("Cơ chế điều chỉnh", { x: 8.4, y: 2.4, w: 4, h: 0.75, fontFace: HEAD, fontSize: 18, bold: true, color: INK, margin: 0, valign: "middle" });
  const rules = [{ i: "FaCheckCircle", t: "Trả lời đúng + nhanh", d: "→ Tăng độ khó câu kế tiếp", c: TEAL }, { i: "FaArrowRight", t: "Đúng nhưng chậm", d: "→ Giữ nguyên độ khó", c: MUTED }, { i: "FaExclamationTriangle", t: "Trả lời sai", d: "→ Giảm độ khó, củng cố lại", c: ACCENT }];
  rules.forEach((r, i) => {
    const y = 3.45 + i * 1.0;
    iconBadge(s, r.i, 7.5, y, 0.55, r.c, "white");
    s.addText(r.t, { x: 8.25, y: y - 0.05, w: 4.2, h: 0.4, fontFace: HEAD, fontSize: 14.5, bold: true, color: INK, margin: 0 });
    s.addText(r.d, { x: 8.25, y: y + 0.32, w: 4.2, h: 0.35, fontFace: BODY, fontSize: 12.5, color: MUTED, margin: 0 });
  });
  s.addText("Đạt ≥ 70% được tính là Pass", { x: 7.45, y: 6.15, w: 5, h: 0.35, fontFace: BODY, fontSize: 11.5, italic: true, color: TEAL, margin: 0 });
  s.addNotes("Tính năng nổi bật 2. Có 3 mức độ khó. Bắt đầu ở mức cơ bản, sau mỗi câu điều chỉnh: đúng và nhanh thì tăng, đúng nhưng chậm thì giữ, sai thì giảm. Ngưỡng đạt 70%. Mỗi người có lộ trình câu hỏi riêng.");

  // ===== 20. THUẬT TOÁN QUIZ (flow) =====
  n = 20; s = darkHead("Tính năng nổi bật 02", "Thuật toán điều chỉnh độ khó", n);
  const algo = [
    { k: "FaPlayCircle", t: "Bắt đầu", d: "Câu đầu tiên ở mức 'basic'" },
    { k: "FaQuestionCircle", t: "Trả lời câu hỏi", d: "Ghi đáp án + thời gian phản hồi" },
    { k: "FaCogs", t: "Đánh giá", d: "Đúng/sai kết hợp nhanh/chậm" },
    { k: "FaStream", t: "Chọn câu kế tiếp", d: "Tăng / giữ / giảm độ khó" },
    { k: "FaPercentage", t: "Kết thúc", d: "Tính điểm, cập nhật level, sinh feedback" },
  ];
  const fw = 2.3, gap = 0.18, startX = 0.7;
  algo.forEach((f, i) => {
    const x = startX + i * (fw + gap);
    s.addShape(pres.shapes.ROUNDED_RECTANGLE, { x, y: 2.85, w: fw, h: 2.55, fill: { color: "12393F" }, line: { color: TEAL, width: 1.2 }, rectRadius: 0.12 });
    s.addShape(pres.shapes.OVAL, { x: x + fw / 2 - 0.4, y: 3.15, w: 0.8, h: 0.8, fill: { color: TEAL }, shadow: sh() });
    s.addImage({ data: ic[f.k].white, x: x + fw / 2 - 0.22, y: 3.33, w: 0.44, h: 0.44 });
    s.addText(f.t, { x: x + 0.1, y: 4.1, w: fw - 0.2, h: 0.45, fontFace: HEAD, fontSize: 14.5, bold: true, color: WHITE, align: "center", margin: 0 });
    s.addText(f.d, { x: x + 0.15, y: 4.6, w: fw - 0.3, h: 0.7, fontFace: BODY, fontSize: 11, color: "B6CBCC", align: "center", margin: 0, lineSpacing: 14 });
    if (i < algo.length - 1) s.addImage({ data: ic.FaArrowRight.accent, x: x + fw + gap / 2 - 0.13, y: 3.9, w: 0.3, h: 0.3 });
  });
  s.addShape(pres.shapes.ROUNDED_RECTANGLE, { x: 0.7, y: 5.75, w: 11.9, h: 0.85, fill: { color: TEAL, transparency: 80 }, line: { type: "none" }, rectRadius: 0.1 });
  s.addText([{ text: "Vòng lặp:  ", options: { bold: true, color: LIGHT_MINT } }, { text: "bước 2 → 3 → 4 lặp lại cho đến khi đủ số câu, rồi chuyển sang bước kết thúc.", options: { color: "E2E8F0" } }], { x: 1.1, y: 5.75, w: 11.1, h: 0.85, fontFace: BODY, fontSize: 13.5, margin: 0, valign: "middle" });
  s.addNotes("Thuật toán quiz thích ứng dưới dạng luồng: bắt đầu ở mức cơ bản, người học trả lời và hệ thống ghi cả thời gian phản hồi, sau đó đánh giá kết hợp đúng/sai với nhanh/chậm để chọn độ khó câu kế tiếp. Vòng lặp này lặp đến khi đủ số câu, rồi tính điểm, cập nhật level và sinh feedback.");

  // ===== 21. HỆ THỐNG FEEDBACK =====
  n = 21; s = lightHead("Phản hồi", "Hệ thống sinh phản hồi", n);
  // two inputs -> output
  s.addShape(pres.shapes.ROUNDED_RECTANGLE, { x: 0.8, y: 2.6, w: 3.2, h: 1.4, fill: { color: CARD2 }, line: { type: "none" }, rectRadius: 0.12, shadow: sh() });
  iconBadge(s, "FaChartLine", 1.1, 2.9, 0.7, TEAL, "white");
  s.addText("Điểm tập trung", { x: 1.95, y: 2.85, w: 1.95, h: 0.5, fontFace: HEAD, fontSize: 14, bold: true, color: INK, margin: 0, valign: "middle" });
  s.addText("từ focus logs", { x: 1.95, y: 3.35, w: 1.95, h: 0.4, fontFace: BODY, fontSize: 11.5, color: MUTED, margin: 0 });
  s.addShape(pres.shapes.ROUNDED_RECTANGLE, { x: 0.8, y: 4.3, w: 3.2, h: 1.4, fill: { color: CARD }, line: { type: "none" }, rectRadius: 0.12, shadow: sh() });
  iconBadge(s, "FaBolt", 1.1, 4.6, 0.7, ACCENT, "white");
  s.addText("Điểm quiz", { x: 1.95, y: 4.55, w: 1.95, h: 0.5, fontFace: HEAD, fontSize: 14, bold: true, color: INK, margin: 0, valign: "middle" });
  s.addText("từ quiz attempt", { x: 1.95, y: 5.05, w: 1.95, h: 0.4, fontFace: BODY, fontSize: 11.5, color: MUTED, margin: 0 });
  s.addImage({ data: ic.FaArrowRight.dark, x: 4.25, y: 3.95, w: 0.6, h: 0.6 });
  s.addShape(pres.shapes.ROUNDED_RECTANGLE, { x: 5.2, y: 2.6, w: 3.0, h: 3.1, fill: { color: DARK }, line: { type: "none" }, rectRadius: 0.12, shadow: sh() });
  iconBadge(s, "FaComments", 6.2, 2.95, 0.9, TEAL, "white");
  s.addText("Feedback\ncá nhân hóa", { x: 5.2, y: 4.0, w: 3.0, h: 0.9, fontFace: HEAD, fontSize: 17, bold: true, color: WHITE, align: "center", margin: 0, lineSpacing: 21 });
  s.addText("recommendation + message", { x: 5.2, y: 4.95, w: 3.0, h: 0.5, fontFace: BODY, fontSize: 11.5, color: LIGHT_MINT, align: "center", margin: 0 });
  // right panel examples
  s.addShape(pres.shapes.ROUNDED_RECTANGLE, { x: 8.6, y: 2.6, w: 4.1, h: 3.1, fill: { color: CARD }, line: { type: "none" }, rectRadius: 0.12 });
  s.addText("Ví dụ gợi ý", { x: 8.9, y: 2.8, w: 3.5, h: 0.4, fontFace: HEAD, fontSize: 15, bold: true, color: INK, margin: 0 });
  s.addText(["Quiz cao + tập trung tốt → học bài tiếp theo", "Quiz thấp → ôn lại & làm quiz mức dễ hơn", "Tập trung kém → nhắc cải thiện môi trường học"].map(t => ({ text: t, options: { bullet: { code: "2022" }, color: INK, breakLine: true, paraSpaceAfter: 12 } })), { x: 8.95, y: 3.35, w: 3.55, h: 2.2, fontFace: BODY, fontSize: 12.5, margin: 0, lineSpacing: 16 });
  s.addNotes("Hệ thống feedback lấy hai đầu vào: điểm tập trung từ focus logs và điểm quiz từ lần làm bài, kết hợp lại để sinh phản hồi cá nhân hóa gồm khuyến nghị và lời nhắn. Ví dụ: điểm cao và tập trung tốt thì gợi ý học bài tiếp; điểm thấp thì gợi ý ôn lại; tập trung kém thì nhắc cải thiện môi trường học.");

  // ===== 22. DASHBOARD =====
  n = 22; s = lightHead("Thống kê", "Dashboard & theo dõi học tập", n);
  // student dashboard: focus distribution as shape-based horizontal bars (no embedded chart)
  s.addText("Phân bố trạng thái tập trung (ví dụ)", { x: 0.6, y: 2.0, w: 6, h: 0.4, fontFace: HEAD, fontSize: 15, bold: true, color: INK, margin: 0 });
  const fdist = [
    { t: "Tập trung", v: 62, c: MINT },
    { t: "Mất tập trung", v: 20, c: ACCENT },
    { t: "Buồn ngủ", v: 10, c: "F97362" },
    { t: "Không có mặt", v: 8, c: "94A3B8" },
  ];
  const barX = 2.35, barMaxW = 3.4, barH = 0.5, rowGap = 0.95;
  fdist.forEach((f, i) => {
    const y = 2.65 + i * rowGap;
    s.addText(f.t, { x: 0.55, y: y - 0.02, w: 1.7, h: barH, fontFace: BODY, fontSize: 12.5, color: INK, align: "right", valign: "middle", margin: 0 });
    s.addShape(pres.shapes.ROUNDED_RECTANGLE, { x: barX, y, w: barMaxW, h: barH, fill: { color: CARD }, line: { type: "none" }, rectRadius: 0.06 });
    s.addShape(pres.shapes.ROUNDED_RECTANGLE, { x: barX, y, w: Math.max(0.25, barMaxW * f.v / 100), h: barH, fill: { color: f.c }, line: { type: "none" }, rectRadius: 0.06 });
    s.addText(`${f.v}%`, { x: barX + barMaxW + 0.1, y, w: 0.7, h: barH, fontFace: HEAD, fontSize: 13, bold: true, color: f.c, valign: "middle", margin: 0 });
  });
  // admin metrics cards
  const dm = [{ k: "FaUsers", t: "Học viên", d: "Số người dùng & học viên hoạt động" }, { k: "FaBolt", t: "Điểm quiz TB", d: "Trung bình điểm các lượt làm bài" }, { k: "FaEye", t: "Focus score TB", d: "Mức độ tập trung trung bình" }, { k: "FaVideo", t: "Lượt xem bài", d: "Tương tác với từng bài giảng" }];
  dm.forEach((d, i) => {
    const col = i % 2, row = Math.floor(i / 2);
    const x = 6.6 + col * 3.1, y = 2.4 + row * 2.05;
    s.addShape(pres.shapes.ROUNDED_RECTANGLE, { x, y, w: 2.9, h: 1.85, fill: { color: i % 2 ? CARD : CARD2 }, line: { type: "none" }, rectRadius: 0.12, shadow: sh() });
    iconBadge(s, d.k, x + 0.3, y + 0.3, 0.62, TEAL, "white");
    s.addText(d.t, { x: x + 0.3, y: y + 1.0, w: 2.4, h: 0.4, fontFace: HEAD, fontSize: 14.5, bold: true, color: INK, margin: 0 });
    s.addText(d.d, { x: x + 0.3, y: y + 1.38, w: 2.4, h: 0.4, fontFace: BODY, fontSize: 10.5, color: MUTED, margin: 0, lineSpacing: 13 });
  });
  s.addNotes("Hệ thống có dashboard cho cả người học và admin. Biểu đồ tròn minh họa phân bố trạng thái tập trung trong một phiên học. Phía admin theo dõi số học viên, điểm quiz trung bình, focus score trung bình và lượt xem từng bài. Số liệu trên biểu đồ là minh họa.");

  // ===== 23. LUỒNG END-TO-END =====
  n = 23; s = darkHead("Quy trình", "Luồng hoạt động khi học một bài", n);
  const flow = [
    { k: "FaSignInAlt", t: "Đăng nhập" },
    { k: "FaVideo", t: "Chọn & xem bài giảng" },
    { k: "FaCamera", t: "Webcam giám sát tập trung" },
    { k: "FaBolt", t: "Làm quiz thích ứng" },
    { k: "FaClipboardCheck", t: "Cập nhật level & feedback" },
  ];
  flow.forEach((f, i) => {
    const x = startX + i * (fw + gap);
    s.addShape(pres.shapes.ROUNDED_RECTANGLE, { x, y: 2.9, w: fw, h: 2.4, fill: { color: "12393F" }, line: { color: TEAL, width: 1.2 }, rectRadius: 0.12 });
    s.addShape(pres.shapes.OVAL, { x: x + fw / 2 - 0.4, y: 3.2, w: 0.8, h: 0.8, fill: { color: TEAL }, shadow: sh() });
    s.addImage({ data: ic[f.k].white, x: x + fw / 2 - 0.22, y: 3.38, w: 0.44, h: 0.44 });
    s.addText(`Bước ${i + 1}`, { x, y: 4.15, w: fw, h: 0.35, fontFace: BODY, fontSize: 11, bold: true, color: LIGHT_MINT, align: "center", margin: 0, charSpacing: 1 });
    s.addText(f.t, { x: x + 0.15, y: 4.45, w: fw - 0.3, h: 0.75, fontFace: HEAD, fontSize: 14, bold: true, color: WHITE, align: "center", margin: 0 });
    if (i < flow.length - 1) s.addImage({ data: ic.FaArrowRight.accent, x: x + fw + gap / 2 - 0.13, y: 3.95, w: 0.3, h: 0.3 });
  });
  s.addText("Kết quả mỗi lượt học được lưu lại để cá nhân hóa các bài học tiếp theo.", { x: 0.7, y: 5.7, w: 11.9, h: 0.5, fontFace: BODY, fontSize: 14.5, italic: true, color: "CBD5E1", align: "center", margin: 0 });
  s.addNotes("Tổng hợp thành vòng lặp học tập thông minh: đăng nhập, xem bài, webcam giám sát, làm quiz thích ứng, cập nhật level và sinh feedback. Dữ liệu lưu lại để cá nhân hóa các bài học sau.");

  // ===== 24. DEMO =====
  n = 24; s = darkHead("Demo", "Demo hệ thống", n);
  const demo = [
    { k: "FaSignInAlt", t: "Đăng nhập & trang chủ", d: "Tài khoản student / admin" },
    { k: "FaCamera", t: "Học bài + webcam AI", d: "Cảnh báo tập trung thời gian thực" },
    { k: "FaBolt", t: "Làm quiz thích ứng", d: "Độ khó thay đổi theo câu trả lời" },
    { k: "FaTachometerAlt", t: "Dashboard admin", d: "Thống kê toàn hệ thống" },
  ];
  demo.forEach((d, i) => {
    const x = 0.9 + i * 3.0;
    s.addShape(pres.shapes.ROUNDED_RECTANGLE, { x, y: 2.7, w: 2.75, h: 2.9, fill: { color: "12393F" }, line: { color: TEAL, width: 1.2 }, rectRadius: 0.12 });
    s.addText(`0${i + 1}`, { x, y: 2.85, w: 2.75, h: 0.6, fontFace: HEAD, fontSize: 22, bold: true, color: LIGHT_MINT, align: "center", margin: 0 });
    iconBadge(s, d.k, x + 2.75 / 2 - 0.4, 3.45, 0.8, TEAL, "white");
    s.addText(d.t, { x: x + 0.15, y: 4.4, w: 2.45, h: 0.6, fontFace: HEAD, fontSize: 14, bold: true, color: WHITE, align: "center", margin: 0 });
    s.addText(d.d, { x: x + 0.15, y: 5.0, w: 2.45, h: 0.5, fontFace: BODY, fontSize: 11, color: "B6CBCC", align: "center", margin: 0, lineSpacing: 14 });
  });
  s.addText("Phần demo trực tiếp trên trình duyệt — chuyển sang ứng dụng để minh họa.", { x: 0.9, y: 6.0, w: 11.5, h: 0.5, fontFace: BODY, fontSize: 14, italic: true, color: "CBD5E1", align: "center", margin: 0 });
  s.addNotes("Đây là slide chuyển sang demo trực tiếp. Trình tự demo gợi ý: đăng nhập và xem trang chủ, vào học một bài có bật webcam để minh họa cảnh báo tập trung, làm quiz để thấy độ khó thay đổi, cuối cùng vào dashboard admin xem thống kê. Nếu không demo trực tiếp được thì thay bằng ảnh chụp màn hình.");

  // ===== 25. KẾT QUẢ =====
  n = 25; s = lightHead("Kết quả", "Kết quả đạt được", n);
  const stats = [
    { num: "11", l: "bảng dữ liệu được\nthiết kế & triển khai", c: TEAL },
    { num: "10", l: "module chức năng\nhoàn thiện", c: MINT },
    { num: "4", l: "trạng thái tập trung\nnhận diện bằng AI", c: ACCENT },
    { num: "3", l: "mức độ khó quiz\nthích ứng tự động", c: DARK },
  ];
  stats.forEach((st, i) => {
    const x = 0.6 + i * 3.05;
    s.addShape(pres.shapes.ROUNDED_RECTANGLE, { x, y: 2.3, w: 2.85, h: 2.4, fill: { color: i % 2 ? CARD2 : CARD }, line: { type: "none" }, rectRadius: 0.12, shadow: sh() });
    s.addText(st.num, { x, y: 2.55, w: 2.85, h: 1.1, fontFace: HEAD, fontSize: 58, bold: true, color: st.c, align: "center", margin: 0 });
    s.addText(st.l, { x: x + 0.2, y: 3.7, w: 2.45, h: 0.85, fontFace: BODY, fontSize: 13, color: INK, align: "center", margin: 0, lineSpacing: 17 });
  });
  s.addShape(pres.shapes.ROUNDED_RECTANGLE, { x: 0.6, y: 5.05, w: 12.1, h: 1.4, fill: { color: DARK }, line: { type: "none" }, rectRadius: 0.12 });
  s.addText([{ text: "Đã chạy được end-to-end:  ", options: { bold: true, color: LIGHT_MINT } }, { text: "đăng nhập → xem bài + webcam AI → quiz thích ứng → feedback → dashboard thống kê.", options: { color: "E2E8F0" } }], { x: 1.0, y: 5.05, w: 11.3, h: 1.4, fontFace: BODY, fontSize: 15.5, margin: 0, valign: "middle", lineSpacing: 22 });
  s.addNotes("Kết quả bằng con số: 11 bảng dữ liệu, 10 module hoàn thiện, AI 4 trạng thái, quiz 3 mức độ khó. Quan trọng nhất là hệ thống đã chạy thông suốt toàn bộ luồng.");

  // ===== 26. HẠN CHẾ & HƯỚNG PHÁT TRIỂN =====
  n = 26; s = lightHead("Đánh giá", "Hạn chế & Hướng phát triển", n);
  s.addShape(pres.shapes.ROUNDED_RECTANGLE, { x: 0.6, y: 2.1, w: 5.95, h: 4.4, fill: { color: CARD }, line: { type: "none" }, rectRadius: 0.12, shadow: sh() });
  iconBadge(s, "FaExclamationTriangle", 0.95, 2.45, 0.75, ACCENT, "white");
  s.addText("Hạn chế hiện tại", { x: 1.85, y: 2.45, w: 4.5, h: 0.75, fontFace: HEAD, fontSize: 18, bold: true, color: INK, margin: 0, valign: "middle" });
  s.addText(["Chưa có JWT / Spring Security bảo vệ API", "Phân quyền mới ở mức frontend route guard", "Độ chính xác AI phụ thuộc ánh sáng & camera", "Chưa có nhận diện danh tính (Face ID)"].map(t => ({ text: t, options: { bullet: { code: "2022" }, color: INK, breakLine: true, paraSpaceAfter: 14 } })), { x: 1.0, y: 3.5, w: 5.3, h: 2.8, fontFace: BODY, fontSize: 14.5, margin: 0 });
  s.addShape(pres.shapes.ROUNDED_RECTANGLE, { x: 6.75, y: 2.1, w: 5.95, h: 4.4, fill: { color: CARD2 }, line: { type: "none" }, rectRadius: 0.12, shadow: sh() });
  iconBadge(s, "FaRocket", 7.1, 2.45, 0.75, TEAL, "white");
  s.addText("Hướng phát triển", { x: 8.0, y: 2.45, w: 4.5, h: 0.75, fontFace: HEAD, fontSize: 18, bold: true, color: INK, margin: 0, valign: "middle" });
  s.addText(["Bổ sung JWT + Spring Security bảo mật API", "Đăng nhập bằng khuôn mặt (Face ID)", "Đa ngôn ngữ Việt – Anh (i18n)", "Cải thiện mô hình AI, thêm cảnh báo realtime"].map(t => ({ text: t, options: { bullet: { code: "2022" }, color: INK, breakLine: true, paraSpaceAfter: 14 } })), { x: 7.15, y: 3.5, w: 5.3, h: 2.8, fontFace: BODY, fontSize: 14.5, margin: 0 });
  s.addNotes("Thẳng thắn nêu hạn chế: chưa có JWT nên API chưa bảo vệ thật, phân quyền mới ở frontend, AI phụ thuộc ánh sáng, chưa có Face ID. Hướng phát triển tương ứng: thêm JWT, đăng nhập bằng khuôn mặt, đa ngôn ngữ, nâng cấp mô hình AI.");

  // ===== 27. KẾT LUẬN =====
  n = 27; s = pres.addSlide();
  s.background = { color: DARK };
  s.addShape(pres.shapes.OVAL, { x: -2.2, y: 3.8, w: 6, h: 6, fill: { color: TEAL, transparency: 80 }, line: { type: "none" } });
  s.addShape(pres.shapes.OVAL, { x: 10.5, y: -2.3, w: 5.5, h: 5.5, fill: { color: MINT, transparency: 82 }, line: { type: "none" } });
  iconBadge(s, "FaCheckCircle", 0.9, 1.5, 0.95, TEAL, "white");
  s.addText("KẾT LUẬN", { x: 0.95, y: 2.65, w: 8, h: 0.45, fontFace: BODY, fontSize: 15, bold: true, color: LIGHT_MINT, charSpacing: 4, margin: 0 });
  s.addText("Một nền tảng học tập\ncá nhân hóa nhờ AI", { x: 0.9, y: 3.1, w: 11, h: 1.7, fontFace: HEAD, fontSize: 38, bold: true, color: WHITE, lineSpacing: 46, margin: 0 });
  s.addShape(pres.shapes.LINE, { x: 0.95, y: 4.95, w: 2.4, h: 0, line: { color: ACCENT, width: 3 } });
  s.addText("Kết hợp giám sát tập trung bằng webcam và quiz thích ứng, hệ thống giúp người học chủ động và hiệu quả hơn — đồng thời cung cấp dữ liệu hữu ích cho giảng viên.", { x: 0.9, y: 5.2, w: 10.8, h: 1.0, fontFace: BODY, fontSize: 16, color: "CBD5E1", margin: 0, lineSpacing: 24 });
  s.addText("Xin cảm ơn thầy/cô và hội đồng đã lắng nghe!", { x: 0.9, y: 6.45, w: 11, h: 0.5, fontFace: HEAD, fontSize: 18, bold: true, italic: true, color: LIGHT_MINT, margin: 0 });
  s.addNotes("Kết luận: hệ thống đã xây dựng nền tảng học tập cá nhân hóa, kết hợp giám sát tập trung bằng webcam và quiz thích ứng. Giá trị: người học chủ động hiệu quả hơn, giảng viên có thêm dữ liệu. Cảm ơn hội đồng và sẵn sàng trả lời câu hỏi.");

  await pres.writeFile({ fileName: "D:/study/final-example/Thuyet_trinh_DATN.pptx" });
  console.log("DONE - slides: 27");
}

build().catch((e) => { console.error(e); process.exit(1); });
