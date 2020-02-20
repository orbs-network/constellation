import { describe, it } from "mocha";
import chai from "chai";
import asserttype from "chai-asserttype";
chai.use(asserttype);

const { expect } = chai;

import { resolvePath } from "../../lib/utils/resolve-path";

describe("path", () => {
  it("should keep absolute path", () => {
    expect(resolvePath("/tmp/hello", __dirname)).to.equal("/tmp/hello");
  });

  it("should expand relative path", () => {
    expect(resolvePath("../hello", __dirname)).to.equal(
      process.cwd() + "/test/hello"
    );
  });

  it("should expand path relative to home", () => {
    expect(resolvePath("~/hello", __dirname)).to.equal(
      process.env.HOME + "/hello"
    );
  });
});
