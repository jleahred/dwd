import { NgPage } from './app.po';

describe('ng App', () => {
  let page: NgPage;

  beforeEach(() => {
    page = new NgPage();
  });

  it('should display welcome message', () => {
    page.navigateTo();
    expect(page.getParagraphText()).toEqual('Welcome to app!');
  });
});
